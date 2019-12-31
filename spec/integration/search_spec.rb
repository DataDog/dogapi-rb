# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  SEARCH_QUERY = 'hosts:database'.freeze

  describe '#search' do
    it_behaves_like 'an api method with params',
                    :search, [],
                    :get, '/search', q: SEARCH_QUERY
  end
end
