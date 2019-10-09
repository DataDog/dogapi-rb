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

  describe '#add_aws_logs_lambda' do
    it_behaves_like 'an api method',
                    :add_aws_logs_lambda, [CONFIG],
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

  describe '#list_aws_logs_integrations' do
    it_behaves_like 'an api method',
                    :list_aws_logs_integrations, nil,
                    :get, '/integration/aws/logs'
  end

  describe '#delete_aws_logs_integration' do
    it_behaves_like 'an api method',
                    :delete_aws_logs_integration, [CONFIG],
                    :delete, '/integration/aws/logs', CONFIG
  end
end
