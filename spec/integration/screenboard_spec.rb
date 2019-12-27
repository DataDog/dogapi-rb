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
