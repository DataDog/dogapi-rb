# encoding: utf-8

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

describe Dogapi::Client do
  COMMENT_ID = 4242
  MESSAGE = 'this is an example message: éè'.freeze

  describe '#comment' do
    it_behaves_like 'an api method with options',
                    :comment, [MESSAGE],
                    :post, '/comments', 'message' => MESSAGE
  end

  describe '#update_comment' do
    it 'queries the api with options' do
      url = api_url + "/comments/#{COMMENT_ID}"
      options = { 'zzz' => 'aaa' }
      stub_request(:put, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:update_comment, COMMENT_ID, options)).to eq ['200', {}]

      expect(WebMock).to have_requested(:put, url)
    end
  end

  describe '#delete_comment' do
    it_behaves_like 'an api method',
                    :delete_comment, [COMMENT_ID],
                    :delete, "/comments/#{COMMENT_ID}"
  end
end
