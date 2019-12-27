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

require_relative '../spec_helper'

describe Dogapi::APIService do
  describe '#connect' do
    let(:url) { api_url + '/awesome' }
    let(:second_url) { 'http://app.example.com/api/v1/awesome' }

    context 'when only the default endpoint is used' do
      let(:service) { Dogapi::APIService.new api_key, app_key }
      context 'and it is up' do
        it 'only queries one endpoint' do
          stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
          expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq(['200', {}])

          expect(WebMock).to have_requested(:get, url)
        end
      end
      context 'and it is down' do
        it 'only queries one endpoint' do
          stub_request(:get, /#{url}/).to_timeout
          expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq([-1, {}])

          expect(WebMock).to have_requested(:get, url)
        end
      end
    end
  end
end
