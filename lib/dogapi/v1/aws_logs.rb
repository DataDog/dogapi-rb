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

    # AwsLogsService for user interaction with AWS configs.
    class AwsLogsService < Dogapi::APIService

      API_VERSION = 'v1'

      # Get the list of current AWS services for which Datadog offers automatic log collection.
      # Use returned service IDs with the services parameter for the Enable
      # an AWS service log collection API endpoint.
      def aws_logs_list_services
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/aws/logs/services", nil, nil, false)
      end

      # Create an AWS integration
      # :config => Hash: integration config.
      # config = {
      #   :account_id => '<AWS_ACCOUNT>',
      #   :lambda_arn => '<LAMBDA_ARN>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.aws_logs_add_lambda(config)
      def aws_logs_add_lambda(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/aws/logs", nil, config, true)
      end

      # List all Datadog-AWS Logs integrations configured in your Datadog account.
      def aws_logs_integrations_list
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/aws/logs", nil, nil, false)
      end

      # Enable automatic log collection for a list of services.
      # This should be run after running 'aws_logs_add_lambda' to save the config.
      # config = {
      #   :account_id => '<AWS_ACCOUNT>',
      #   :services => ['s3', 'elb', 'elbv2', 'cloudfront', 'redshift', 'lambda']
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.aws_logs_save_services(config)
      def aws_logs_save_services(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/aws/logs/services", nil, config, true)
      end

      # Delete an AWS Logs integration
      # :config => Hash: integration config.
      # config = {
      #   :account_id => '<AWS_ACCOUNT>',
      #   :lambda_arn => '<LAMBDA_ARN>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.aws_logs_integration_delete(config)
      def aws_logs_integration_delete(config)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/aws/logs", nil, config, true)
      end

      # Check function to see if a lambda_arn exists within an account.
      # This sends a job on our side if it does not exist, then immediately returns
      # the status of that job. Subsequent requests will always repeat the above, so this endpoint
      # can be polled intermittently instead of blocking.

      # Returns a status of 'created' when it's checking if the Lambda exists in the account.
      # Returns a status of 'waiting' while checking.
      # Returns a status of 'checked and ok' if the Lambda exists.
      # Returns a status of 'error' if the Lambda does not exist.

      # contents of config should be
      # >>> :account_id => '<AWS_ACCOUNT_ID>'
      # >>> :lambda_arn => '<AWS_LAMBDA_ARN>'

      def aws_logs_check_lambda(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/aws/logs/check_async", nil, config, true)
      end

      # Test if permissions are present to add log-forwarding triggers for the
      # given services + AWS account. Input is the same as for save_services.
      # Done async, so can be repeatedly polled in a non-blocking fashion until
      # the async request completes

      # Returns a status of 'created' when it's checking if the permissions exists in the AWS account.
      # Returns a status of 'waiting' while checking.
      # Returns a status of 'checked and ok' if the Lambda exists.
      # Returns a status of 'error' if the Lambda does not exist.

      # contents of config should be
      # :account_id => '<AWS_ACCOUNT_ID>'
      # :services => ['s3', 'elb', 'elbv2', 'cloudfront', 'redshift', 'lambda']
      def aws_logs_check_services(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/aws/logs/services_async", nil, config, true)
      end

    end

  end
end
