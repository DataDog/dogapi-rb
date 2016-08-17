require 'spec_helper'

describe Dogapi::Client do
  before(:each) do
    @dogmock = Dogapi::Client.new(api_key, app_key)
    @service = @dogmock.instance_variable_get(:@metric_svc)
    @service.instance_variable_set(:@uploaded, [])
    def @service.upload(payload)
      @uploaded << payload
      [200, {}]
    end
  end

  describe '#emit_point' do
    it 'passes data' do
      @dogmock.emit_point('metric.name', 0, host: 'myhost')

      uploaded = @service.instance_variable_get(:@uploaded)
      expect(uploaded.length).to eq 1
      series = uploaded.first
      expect(series.class).to eq Array
      expect(series[0][:metric]).to eq 'metric.name'
      expect(series[0][:points][0][1]).to eq 0
      expect(series[0][:host]).to eq 'myhost'
    end

    it 'uses localhost default' do
      @dogmock.emit_point('metric.name', 0)

      uploaded = @service.instance_variable_get(:@uploaded)
      series = uploaded.first
      expect(series[0][:host]).to eq Dogapi.find_localhost
    end

    it 'can pass nil host' do
      @dogmock.emit_point('metric.name', 0, host: nil)

      uploaded = @service.instance_variable_get(:@uploaded)
      series = uploaded.first
      expect(series[0][:host]).to be_nil
    end

    it 'can be batched' do
      code, = @dogmock.batch_metrics do
        @dogmock.emit_point('metric.name', 1, type: 'counter')
        @dogmock.emit_point('othermetric.name', 2, type: 'counter')
      end
      expect(code).to eq 200
      # Verify that we uploaded what we expected
      uploaded = @service.instance_variable_get(:@uploaded)
      expect(uploaded.length).to eq 1
      series = uploaded.first
      expect(series.class).to eq Array
      expect(series[0][:metric]).to eq 'metric.name'
      expect(series[0][:points][0][1]).to eq 1
      expect(series[0][:type]).to eq 'counter'
      expect(series[1][:metric]).to eq 'othermetric.name'
      expect(series[1][:points][0][1]).to eq 2
      expect(series[1][:type]).to eq 'counter'

      # Verify that the buffer was correclty emptied
      buffer = @service.instance_variable_get(:@buffer)
      expect(buffer).to be nil
    end

    it 'flushes the buffer even if an exception is raised' do
      buffer = []
      begin
        @dogmock.batch_metrics do
          @dogmock.emit_point('metric.name', 1, type: 'counter')
          raise 'Oh no, something went wrong'
        end
      rescue
        buffer = @service.instance_variable_get(:@buffer)
      end
      expect(buffer).to be nil
    end
  end

  describe '#format_endpoints' do
    context 'when no extra_endpoints is given' do
      it 'returns the default endpoint and api keys' do
        client = Dogapi::Client.new api_key, app_key
        expected_endpoints = { 'http://app.datadoghq.com' => [[api_key, app_key]] }
        expect(client.instance_variable_get(:@endpoints)).to eq(expected_endpoints)
      end
    end
    context 'when an Array extra_endpoints is given' do
      it 'returns the endpoint with all the keys' do
        extra_endpoints = [%w(api_key1 app_key2), ['api_key3', nil]]
        client = Dogapi::Client.new api_key, app_key, nil, nil, true, nil, extra_endpoints
        expected_endpoints = { 'http://app.datadoghq.com' => [[api_key, app_key]] + extra_endpoints }
        expect(client.instance_variable_get(:@endpoints)).to eq(expected_endpoints)
      end
    end
    context 'when a Hash extra_endpoints is given' do
      it 'returns the endpoints with all the keys' do
        extra_keys = [%w(api_key1 app_key2), ['api_key3', nil]]
        extra_endpoints = { 'http://app.datadoghq.com' => [%w(api_key2 app_key2)],
                            'http://app.example.com' => extra_keys }
        client = Dogapi::Client.new api_key, app_key, nil, nil, true, nil, extra_endpoints
        expected_endpoints = { 'http://app.datadoghq.com' => [[api_key, app_key]] + [%w(api_key2 app_key2)],
                               'http://app.example.com' => extra_keys }
        expect(client.instance_variable_get(:@endpoints)).to eq(expected_endpoints)
      end
    end
    context 'when a bad extra_endpoints is given' do
      it 'raises an error' do
        extra_endpoints = '{}'
        expect { Dogapi::Client.new api_key, app_key, nil, nil, true, nil, extra_endpoints }.to raise_error(
          RuntimeError,
          'extra_endpoints has to be an Array or a Hash: {}'
        )
      end
    end
  end
end
