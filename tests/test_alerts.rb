require 'dogapi'
require 'time'
require 'test_base.rb'

class TestAlerts < Minitest::Test
  include TestBase

  def test_alerts
    dog = Dogapi::Client.new(@api_key, @app_key)

    query = 'avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100'

    alert_id = dog.alert(query)[1]['id']
    status, alert = dog.get_alert(alert_id)
    assert_equal alert['query'], query, alert['query']
    assert_equal alert['silenced'], false, alert['silenced']

    dog.update_alert(alert_id, query, :silenced => true)
    status, alert = dog.get_alert(alert_id)
    assert_equal alert['query'], query, alert['query']
    assert_equal alert['silenced'], true, alert['silenced']

    dog.delete_alert(alert_id)

    query1 = 'avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100'
    query2 = 'avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 200'

    alert_id1 = dog.alert(query1)[1]['id']
    alert_id2 = dog.alert(query2)[1]['id']
    status, alerts = dog.get_all_alerts()
    alerts = alerts['alerts']
    alert1 = alerts.select {|a| a['id'] == alert_id1}
    alert2 = alerts.select {|a| a['id'] == alert_id2}
    assert_equal alert1[0]['query'], query1, alert1
    assert_equal alert2[0]['query'], query2, alert2

  end
end
