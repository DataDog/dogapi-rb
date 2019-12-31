# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
