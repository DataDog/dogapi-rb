require_relative '../spec_helper'

describe Dogapi::Client do
  SC_BODY = { check: 'app.is_ok', host_name: 'app1', status: 0 }.freeze
  SC_ARGS = SC_BODY.values

  describe '#service_check' do
    it_behaves_like 'an api method with options',
                    :service_check, SC_ARGS,
                    :post, '/check_run', SC_BODY
  end
end
