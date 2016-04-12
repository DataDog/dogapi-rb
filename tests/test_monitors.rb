require 'dogapi'
require 'time'
require 'test_base.rb'

class TestAlerts < Minitest::Test
  include TestBase

  def test_metric_alerts
    dog = Dogapi::Client.new(@api_key, @app_key)

    query = 'sum(last_1d):sum:system.net.bytes_rcvd{host:host0} > 100'
    options = {
        'silenced' => {'*' => nil},
        'notify_no_data' => false
    }

    monitor_id = dog.monitor('metric alert', query, :options=>options)[1]['id']
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['query'], query, monitor['query']
    assert_equal monitor['options']['silenced'], options['silenced'], monitor['options']

    query2 = 'avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 200'
    updated_monitor_id = dog.update_monitor(monitor_id, query2,
                                :options => options)[1]['id']
    status, monitor = dog.get_monitor(updated_monitor_id)
    assert_equal monitor['query'], query2, monitor['query']

    name = 'test_monitors'
    monitor_id = dog.update_monitor(monitor_id, query2, :name => name,
        :options=>{'notify_no_data' => true})[1]['id']
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['name'], name, monitor['name']
    assert_equal monitor['options']['notify_no_data'], true, monitor['options']

    dog.delete_monitor(monitor_id)
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal status.to_i, 404, status.to_i

    query1 = "avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100"
    query2 = "avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 200"
    query3 = "avg(last_1h):sum:system.net.bytes_rcvd{host:host1} > 200"

    monitor_id1 = dog.monitor('metric alert', query1)[1]['id']
    monitor_id2 = dog.monitor('metric alert', query2)[1]['id']
    monitor_id3 = dog.monitor('metric alert', query3)[1]['id']
    status, monitors = dog.get_all_monitors(:group_states => ['alert', 'warn'])
    monitor1 = monitors.map{|m| m if m['id'] == monitor_id1}.compact[0]
    monitor2 = monitors.map{|m| m if m['id'] == monitor_id2}.compact[0]
    assert_equal monitor1['query'], query1, monitor1['query']
    assert_equal monitor2['query'], query2, monitor2['query']

    status, monitors = dog.get_all_monitors(:tags => ['host:host1'])
    monitor3 = monitors.map{|m| m if m['id'] == monitor_id3}.compact[0]
    assert_equal monitor3['query'], query3, monitor3['query']
    assert_equal nil, monitors.map{|m| m if m['id'] == monitor_id1}.compact[0]
    assert_equal nil, monitors.map{|m| m if m['id'] == monitor_id2}.compact[0]

    dog.delete_monitor(monitor_id1)
    dog.delete_monitor(monitor_id2)
    dog.delete_monitor(monitor_id3)
  end

  def test_checks
    dog = Dogapi::Client.new(@api_key, @app_key)

    query = '"ntp.in_sync".over("role:herc").last(3).count_by_status()'
    options = {
        'notify_no_data' => false,
        'thresholds' => {
            'ok' => 3,
            'warning' => 2,
            'critical' => 1,
            'no data' => 3
        }
    }
    monitor_id = dog.monitor('service check', query, :options => options)[1]['id']
    status, monitor = dog.get_monitor(monitor_id, :group_states => ['all'])

    assert_equal monitor['query'], query, monitor['query']
    assert_equal monitor['options']['notify_no_data'], options['notify_no_data'], monitor['options']
    assert_equal monitor['options']['thresholds'], options['thresholds'], monitor['options']

    query2 = '"ntp.in_sync".over("role:sobotka").last(3).count_by_status()'
    monitor_id = dog.update_monitor(monitor_id, query2)[1]['id']
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['query'], query2, monitor['query']

    dog.delete_monitor(monitor_id)
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal status.to_i, 404, status.to_i
  end

  def test_monitor_muting
    dog = Dogapi::Client.new(@api_key, @app_key)

    query = 'avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100'
    monitor_id = dog.monitor('metric alert', query)[1]['id']
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['query'], query, monitor['query']

    status, dt = dog.mute_monitors()
    assert_equal dt['active'], true, dt['active']
    assert_equal dt['scope'], ['*'], dt['scope']

    status, dt = dog.unmute_monitors()
    assert_equal status.to_i, 204, status.to_i

    # We shouldn't be able to mute a simple alert on a scope.
    status, _ = dog.mute_monitor(monitor_id, :scope => 'env:staging')
    assert_equal status.to_i, 400, status.to_i

    query2 = 'avg(last_1h):sum:system.net.bytes_rcvd{*} by {host} > 100'
    monitor_id = dog.monitor('metric alert', query2)[1]['id']
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['query'], query2, monitor['query']

    dog.mute_monitor(monitor_id, :scope => 'host:foo')
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['options']['silenced'], {'host:foo' => nil}, monitor['options']

    dog.unmute_monitor(monitor_id, :scope => 'host:foo')
    status, monitor = dog.get_monitor(monitor_id)
    assert_equal monitor['options']['silenced'], {}, monitor['options']

    dog.delete_monitor(monitor_id)
  end

  def test_downtime
    dog = Dogapi::Client.new(@api_key, @app_key)
    start_ts = Time.now.to_i
    end_ts = start_ts + 1000
    downtime_id = dog.schedule_downtime('env:staging', :start => start_ts,
                                        :end => end_ts, :message=>'Message!')[1]['id']
    status, dt = dog.get_downtime(downtime_id)
    assert_equal dt['start'], start_ts, dt['start']
    assert_equal dt['end'], end_ts, dt['end']
    assert_equal dt['scope'], ['env:staging'], dt['scope']
    assert_equal dt['message'], 'Message!', dt['messsage']

    dog.update_downtime(downtime_id, :start => start_ts + 1, :end => end_ts + 1,
                        :scope => 'env:prod', :message => 'New Message!')
    status, dt = dog.get_downtime(downtime_id)
    assert_equal dt['start'], start_ts + 1, dt['start']
    assert_equal dt['end'], end_ts + 1, dt['end']
    assert_equal dt['scope'], ['env:prod'], dt['scope']
    assert_equal dt['message'], 'New Message!', dt['messsage']

    dog.cancel_downtime(downtime_id)
  end

  def test_host_muting
    dog = Dogapi::Client.new(@api_key, @app_key)

    hostname = 'test.host%d' % rand(10000)

    # Reset test
    dog.unmute_host(hostname)

    message = "Muting this host for a test."
    end_ts = Time.now.to_i + 60 * 60

    res_code, res = dog.mute_host(hostname, :end => end_ts, :message => message)
    assert_equal res_code, "200", res_code
    assert_equal res["action"], "Muted", res["action"]
    assert_equal res["hostname"], hostname, res["hostname"]
    assert_equal res["message"], message, res["message"]
    assert_equal res["end"], end_ts, res["end"]

    # muting the same host multiple times should fail unless override is true
    end_ts2 = end_ts + 60 * 15
    res_code, res = dog.mute_host(hostname, :end => end_ts2)
    assert_equal res_code, "400", res_code

    res_code, res = dog.mute_host(hostname, :end => end_ts2, :override => true)
    assert_equal res_code, "200", res_code
    assert_equal res["action"], "Muted", res["action"]
    assert_equal res["hostname"], hostname, res["hostname"]
    assert_equal res["end"], end_ts2, res["end"]

    res_code, res = dog.unmute_host(hostname)
    assert_equal res_code, "200", res_code
    assert_equal res["action"], "Unmuted", res["action"]
    assert_equal res["hostname"], hostname, res["hostname"]
  end

  def test_service_checks
    dog = Dogapi::Client.new(@api_key, @app_key)
    status, response = dog.service_check('app.ok', 'app1', 1)
    assert_equal status.to_i, 202
  end

end
