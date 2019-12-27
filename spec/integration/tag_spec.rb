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
  HOST_NAME = 'test.example.com'.freeze
  SOURCE = 'chef_custom'.freeze
  TAGS = ['role:web', 'environment:test'].freeze

  describe '#add_tags' do
    context 'whithout precising the source' do
      it_behaves_like 'an api method',
                      :add_tags, [HOST_NAME, TAGS],
                      :post, "/tags/hosts/#{HOST_NAME}", tags: TAGS
    end
    context 'while precising the source' do
      it_behaves_like 'an api method with params',
                      :add_tags, [HOST_NAME, TAGS],
                      :post, "/tags/hosts/#{HOST_NAME}", source: SOURCE
    end
  end

  describe '#update_tags' do
    context 'whithout precising the source' do
      it_behaves_like 'an api method',
                      :update_tags, [HOST_NAME, TAGS],
                      :put, "/tags/hosts/#{HOST_NAME}", tags: TAGS
    end
    context 'while precising the source' do
      it_behaves_like 'an api method with params',
                      :update_tags, [HOST_NAME, TAGS],
                      :put, "/tags/hosts/#{HOST_NAME}", source: SOURCE
    end
  end

  describe '#host_tags' do
    context 'whithout precising the source' do
      it_behaves_like 'an api method',
                      :host_tags, [HOST_NAME],
                      :get, "/tags/hosts/#{HOST_NAME}"
    end
    context 'while precising the source' do
      it_behaves_like 'an api method with params',
                      :host_tags, [HOST_NAME],
                      :get, "/tags/hosts/#{HOST_NAME}", source: SOURCE, by_source: true
    end
  end

  describe '#detach_tags' do
    context 'whithout precising the source' do
      it_behaves_like 'an api method',
                      :detach_tags, [HOST_NAME],
                      :delete, "/tags/hosts/#{HOST_NAME}"
    end

    context 'while precising the source' do
      it_behaves_like 'an api method with params',
                      :detach_tags, [HOST_NAME],
                      :delete, "/tags/hosts/#{HOST_NAME}", source: SOURCE
    end
  end

  describe '#all_tags' do
    it_behaves_like 'an api method',
                    :all_tags, [],
                    :get, '/tags/hosts'
  end
end
