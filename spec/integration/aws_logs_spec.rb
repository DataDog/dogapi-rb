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
  CONFIG = {
    account_id: '123456789101',
    lambda_arn: 'arn:aws:lambda:us-east-1:123456789101:function:LogsCollectionAPITest'
  }.freeze

  SERVICES_CONFIG = {
    account_id: '601427279990',
    services: %w([s3] [elb] [elbv2] [cloudfront] [redshift] [lambda])
  }.freeze

  describe '#aws_logs_add_lambda' do
    it_behaves_like 'an api method',
                    :aws_logs_add_lambda, [CONFIG],
                    :post, '/integration/aws/logs', CONFIG
  end

  describe '#aws_logs_save_services' do
    it_behaves_like 'an api method',
                    :aws_logs_save_services, [SERVICES_CONFIG],
                    :post, '/integration/aws/logs/services', SERVICES_CONFIG
  end

  describe '#aws_logs_check_services' do
    it_behaves_like 'an api method',
                    :aws_logs_check_services, [SERVICES_CONFIG],
                    :post, '/integration/aws/logs/services_async', SERVICES_CONFIG
  end

  describe '#aws_logs_check_lambda' do
    it_behaves_like 'an api method',
                    :aws_logs_check_lambda, [CONFIG],
                    :post, '/integration/aws/logs/check_async', CONFIG
  end

  describe '#aws_logs_list_services' do
    it_behaves_like 'an api method',
                    :aws_logs_list_services, nil,
                    :get, '/integration/aws/logs/services'
  end

  describe '#aws_logs_integrations_list' do
    it_behaves_like 'an api method',
                    :aws_logs_integrations_list, nil,
                    :get, '/integration/aws/logs'
  end

  describe '#aws_logs_integration_delete' do
    it_behaves_like 'an api method',
                    :aws_logs_integration_delete, [CONFIG],
                    :delete, '/integration/aws/logs', CONFIG
  end
end
