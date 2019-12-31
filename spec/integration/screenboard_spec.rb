# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  BOARD_ID = 4_242_424_242
  SCREEN_DESCRIPTION = {
    'width' => 1024,
    'height' => 768,
    'board_title' => 'dogapi test',
    'widgets' => [
      {
        'type' => 'image',
        'height' => 20,
        'width' => 32,
        'y' => 7,
        'x' => 32,
        'url' => 'https://path/to/image.jpg'
      }
    ]
  }.freeze
  describe '#create_screenboard' do
    it_behaves_like 'an api method',
                    :create_screenboard, [SCREEN_DESCRIPTION],
                    :post, '/screen', SCREEN_DESCRIPTION
  end

  describe '#update_screenboard' do
    it_behaves_like 'an api method',
                    :update_screenboard, [BOARD_ID] + [SCREEN_DESCRIPTION],
                    :put, "/screen/#{BOARD_ID}", SCREEN_DESCRIPTION
  end

  describe '#get_screenboard' do
    it_behaves_like 'an api method',
                    :get_screenboard, [BOARD_ID],
                    :get, "/screen/#{BOARD_ID}"
  end

  describe '#get_all_screenboards' do
    it_behaves_like 'an api method',
                    :get_all_screenboards, [],
                    :get, '/screen'
  end

  describe '#delete_screenboard' do
    it_behaves_like 'an api method',
                    :delete_screenboard, [BOARD_ID],
                    :delete, "/screen/#{BOARD_ID}"
  end

  describe '#share_screenboard' do
    it_behaves_like 'an api method',
                    :share_screenboard, [BOARD_ID],
                    :post, "/screen/share/#{BOARD_ID}"
  end

  describe '#revoke_screenboard' do
    it_behaves_like 'an api method',
                    :revoke_screenboard, [BOARD_ID],
                    :delete, "/screen/share/#{BOARD_ID}"
  end
end
