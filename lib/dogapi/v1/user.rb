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

require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class UserService < Dogapi::APIService

      API_VERSION = 'v1'

      # <b>DEPRECATED:</b> Going forward, we're using a new and more restful API,
      # the new methods are get_user, create_user, update_user, disable_user
      def invite(emails, options= {})
        warn '[DEPRECATION] Dogapi::V1::UserService::invite has been deprecated '\
             'in favor of Dogapi::V1::UserService::create_user'
        body = {
          'emails' => emails,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/invite_users", nil, body, true)
      end

      # Create a user
      #
      # :description => Hash: user description containing 'handle' and 'name' properties
      def create_user(description= {})
        request(Net::HTTP::Post, "/api/#{API_VERSION}/user", nil, description, true)
      end

      # Retrieve user information
      #
      # :handle => String: user handle
      def get_user(handle)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/user/#{handle}", nil, nil, false)
      end

      # Retrieve all users
      def get_all_users
        request(Net::HTTP::Get, "/api/#{API_VERSION}/user", nil, nil, false)
      end

      # Update a user
      #
      # :handle => String: user handle
      # :description => Hash: user description optionally containing 'name', 'email',
      # 'is_admin', 'disabled' properties
      def update_user(handle, description= {})
        request(Net::HTTP::Put, "/api/#{API_VERSION}/user/#{handle}", nil, description, true)
      end

      # Disable a user
      #
      # :handle => String: user handle
      def disable_user(handle)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/user/#{handle}", nil, nil, false)
      end

    end

  end
end
