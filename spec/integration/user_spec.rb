# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  USER_HANDLE = 'test@example.com'.freeze
  USER_DESCRIPTION = {
    handle: USER_HANDLE,
    name: 'TEST'
  }.freeze
  USER_EMAILS = (1..4).map { |i| "test#{i}@example.com" }

  describe '#invite' do
    it_behaves_like 'an api method with options',
                    :invite, [USER_EMAILS],
                    :post, '/invite_users', 'emails' => USER_EMAILS
  end

  describe '#create_user' do
    it_behaves_like 'an api method',
                    :create_user, [USER_DESCRIPTION],
                    :post, '/user', USER_DESCRIPTION
  end

  describe '#get_user' do
    it_behaves_like 'an api method',
                    :get_user, [USER_HANDLE],
                    :get, "/user/#{USER_HANDLE}"
  end

  describe '#get_all_users' do
    it_behaves_like 'an api method',
                    :get_all_users, [],
                    :get, '/user'
  end

  describe '#update_user' do
    it_behaves_like 'an api method',
                    :update_user, [USER_HANDLE, USER_DESCRIPTION],
                    :put, "/user/#{USER_HANDLE}", USER_DESCRIPTION
  end

  describe '#disable_user' do
    it_behaves_like 'an api method',
                    :disable_user, [USER_HANDLE],
                    :delete, "/user/#{USER_HANDLE}"
  end
end
