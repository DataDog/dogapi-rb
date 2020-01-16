# encoding: utf-8

# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
