# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
