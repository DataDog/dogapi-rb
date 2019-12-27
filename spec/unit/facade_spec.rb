# Copyright (c) 2010-2020, Datadog <opensource@datadoghq.com>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
# following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
# disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

equire 'spec_helper'

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

  describe 'Datadog API url' do
    it 'can be set in initializer' do
      client = Dogapi::Client.new(api_key, app_key, nil, nil, nil, nil, 'example.com')
      expect(client.datadog_host).to eq 'example.com'
    end

    it 'can be set with instance var' do
      client = Dogapi::Client.new(api_key, app_key)
      client.datadog_host = 'example.com'
      expect(client.datadog_host).to eq 'example.com'
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
end
