require_relative '../spec_helper'

describe Dogapi::Client do
  SEARCH_QUERY = 'hosts:database'.freeze

  describe '#search' do
    it_behaves_like 'an api method with params',
                    :search, [],
                    :get, '/search', q: SEARCH_QUERY
  end
end
