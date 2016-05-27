require 'spec_helper'

describe 'Facade', :vcr => true do
  before(:all) do
    @api_key = ENV['DATADOG_API_KEY']
    @app_key = ENV['DATADOG_APP_KEY']
    @job_number = ENV['TRAVIS_JOB_NUMBER'] || '1'
    @dog = Dogapi::Client.new(@api_key, @app_key)
  end

  context 'Client' do
    let('metric') { 'metric.name' }
    let(:uploaded) { @service.instance_variable_get(:@uploaded) }
    let(:series) { @service.instance_variable_get(:@uploaded).first }

    before(:each) do
      @dogmock = Dogapi::Client.new(@api_key, @app_key)
      @service = @dogmock.instance_variable_get(:@metric_svc)
      @service.instance_variable_set(:@uploaded, [])
      def @service.upload(payload)
        @uploaded << payload
        200
      end
    end

    it 'emit_point passes data' do
      @dogmock.emit_point(metric, 0, host: 'myhost')

      expect(uploaded.length).to eq 1
      series = uploaded.first
      expect(series.class).to eq Array
      expect(series[0][:metric]).to eq metric
      expect(series[0][:points][0][1]).to eq 0
      expect(series[0][:host]).to eq 'myhost'
    end

    it 'emit_point uses localhost default' do
      @dogmock.emit_point(metric, 0)
      expect(series[0][:host]).to eq Dogapi.find_localhost
    end

    it 'emit_point can pass nil host' do
      @dogmock.emit_point(metric, 0, host: nil)
      series = @service.instance_variable_get(:@uploaded).first
      expect(series[0][:host]).to be_nil
    end

    it 'emit_points can be batched' do
      code, _resp = @dogmock.batch_metrics do
        @dogmock.emit_point(metric, 1, type: 'counter')
        @dogmock.emit_point('othermetric.name', 2, type: 'counter')
      end

      expect(code).to eq 200
      # Verify that we uploaded what we expected
      uploaded = @service.instance_variable_get(:@uploaded)
      expect(uploaded.length).to eq 1
      series = uploaded.first
      expect(series.class).to eq Array
      expect(series[0][:metric]).to eq metric
      expect(series[0][:points][0][1]).to eq 1
      expect(series[0][:type]).to eq 'counter'
      expect(series[1][:metric]).to eq 'othermetric.name'
      expect(series[1][:points][0][1]).to eq 2
      expect(series[1][:type]).to eq 'counter'

      # Verify that the buffer was correclty emptied
      expect(@service.instance_variable_get(:@buffer)).to be nil
    end

    it 'flushes the buffer even if an exception is raised' do
      begin
        @dogmock.batch_metrics do
          @dogmock.emit_point(metric, 1, type: 'counter')
          raise 'Oh no, something went wrong'
        end
      rescue
      end
      buffer = @service.instance_variable_get(:@buffer)
      expect(buffer).to be nil
    end
  end

  context 'Events' do
    let(:now) { Time.now }
    let(:title) { "dogapi-rb end test title #{now.to_i.to_s}" }
    let(:message) { 'test message' }

    it 'emits events and retrieves them' do
      # Tag the events with the build number, because Travis parallel testing
      # can cause problems with the event stream
      tags = ["test-run:#{@job_number}"]
      event = Dogapi::Event.new(message, msg_title: title, date_happened: now, tags: tags)

      _code, resp = @dog.emit_event(event)
      now_event_id = resp["event"]["id"]
      sleep 8

      _code, resp = @dog.get_event(now_event_id)

      expect(resp['event']).not_to be_nil
      expect(resp['event']['text']).to eq(message)
    end

    it 'emits events with specified priority' do
      event = Dogapi::Event.new(message, msg_title: 'title', date_happened: now, priority: 'low')
      _code, resp = @dog.emit_event(event)
      low_event_id = resp['event']['id']
      sleep 8

      _code, resp = @dog.get_event(low_event_id)
      expect(resp['event']).not_to be_nil
      low_event = resp['event']
      expect(low_event['priority']).to eq('low')
    end

    it 'emits aggregate events' do
      _code, resp = @dog.emit_event(
        Dogapi::Event.new('Testing Aggregation (first)', aggregation_key: now.to_i)
      )
      first = resp['event']['id']

      _code, resp = @dog.emit_event(
        Dogapi::Event.new('Testing Aggregation (second)', aggregation_key: now.to_i)
      )
      second = resp['event']['id']
      sleep 8

      _code, resp = @dog.get_event(first)
      expect(resp['event']).not_to be_nil
      _code, resp = @dog.get_event(second)
      expect(resp['event']).not_to be_nil
    end
  end

  context 'Tags' do
    let(:hostname) { 'test.tag.host' }
    let(:tags) { %W(test.tag.1 test.tag.2 test.tag.3) }

    it 'adds, updates and detaches tags' do
      @dog.emit_point('test.tag.metric', 1, host: hostname)
      sleep 5

      @dog.detach_tags(hostname)
      _code, resp = @dog.host_tags(hostname)
      expect(resp['tags']).to be_empty

      tags.each_index do |i|
        @dog.add_tags(hostname, tags.first(i + 1))
        _code, resp = @dog.host_tags(hostname)
        expect(resp['tags']).to match_array(tags.first(i + 1))
      end

      @dog.detach_tags(hostname)

      _code, resp = @dog.host_tags(hostname)
      expect(resp['tags']).to be_empty
    end
  end
end
