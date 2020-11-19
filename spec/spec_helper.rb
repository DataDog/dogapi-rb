# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'rspec'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start do
  add_filter 'spec'
end

webmock_allow = []

begin
  require 'ddtrace'
  Datadog.configure do |c|
    c.use :rspec, service_name: 'dogapi-rb'
  end
  webmock_allow << "#{Datadog::Transport::HTTP.default_hostname}:#{Datadog::Transport::HTTP.default_port}"
rescue LoadError
  puts 'ddtrace gem not found'
end

WebMock.disable_net_connect!(allow_localhost: false, allow: webmock_allow)

# include our code and methods
require 'dogapi'

DATADOG_HOST = 'api.datadoghq.com'.freeze
ENV['DATADOG_HOST'] = 'http://' + DATADOG_HOST

module SpecDog
  extend RSpec::SharedContext

  let(:api_key) { 'API_KEY' }
  let(:app_key) { 'APP_KEY' }
  let(:dog) { Dogapi::Client.new(api_key, app_key, 'data.dog', nil, false) }
  let(:dog2) { Dogapi::ClientV2.new(api_key, app_key, 'data.dog', nil, false) }
  let(:api_url) { "#{DATADOG_HOST}/api/v1" }
  let(:old_api_url) { "#{DATADOG_HOST}/api" }
  let(:api_v2_url) { "#{DATADOG_HOST}/api/v2" }

  let(:default_query) { { api_key: api_key, application_key: app_key } }

  shared_examples 'an api method' do |command, args, request, endpoint, body|
    it 'queries the api' do
      url = api_url + endpoint
      old_url = old_api_url + endpoint
      stub_request(request, /#{url}|#{old_url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(command, *args)).to eq ['200', {}]

      body = MultiJson.dump(body) if body

      expect(WebMock).to have_requested(request, /#{url}|#{old_url}/).with(
        body: body
      )
    end
  end

  shared_examples 'an api method with options' do |command, args, request, endpoint, body|
    include_examples 'an api method', command, args, request, endpoint, body
    it 'queries the api with options' do
      url = api_url + endpoint
      old_url = old_api_url + endpoint
      options = { 'zzz' => 'aaa' }
      stub_request(request, /#{url}|#{old_url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(command, *args, options)).to eq ['200', {}]

      body = MultiJson.dump(body ? (body.merge options) : options)

      expect(WebMock).to have_requested(request, /#{url}|#{old_url}/).with(
        body: body
      )
    end
  end

  shared_examples 'an api method with params' do |command, args, request, endpoint, params|
    it 'queries the api with params' do
      url = api_url + endpoint
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(command, *args, *params.values)).to eq ['200', {}]
      params.each { |k, v| params[k] = v.join(',') if v.is_a? Array }
      params = params

      expect(WebMock).to have_requested(request, url).with(
        query: params
      )
    end
  end

  shared_examples 'an api method with params and body' do |command, args, request, endpoint, params, body|
    it 'queries the api with params and body' do
      url = api_url + endpoint
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(command, *args)).to eq ['200', {}]
      params.each { |k, v| params[k] = v.join(',') if v.is_a? Array }
      params = params

      body = MultiJson.dump(body) if body

      expect(WebMock).to have_requested(request, url).with(
        query: params,
        body: body
      )
    end
  end

  shared_examples 'an api method with optional params' do |command, args, request, endpoint, opt_params|
    include_examples 'an api method', command, args, request, endpoint
    it 'queries the api with optional params' do
      url = api_url + endpoint
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(command, *args, opt_params)).to eq ['200', {}]

      opt_params.each { |k, v| opt_params[k] = v.join(',') if v.is_a? Array }
      params = opt_params

      expect(WebMock).to have_requested(request, url).with(
        query: params
      )
    end
  end

  # Support for new API version (v2)

  shared_examples 'an api v2 method' do |command, args, request, endpoint, body|
    it 'queries the api v2' do
      url = api_v2_url + endpoint
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog2.send(command, *args)).to eq ['200', {}]
      body = MultiJson.dump(body) if body

      expect(WebMock).to have_requested(request, url).with(
        body: body
      )
    end
  end

  shared_examples 'an api v2 method with options' do |command, args, request, endpoint, body|
    include_examples 'an api method', command, args, request, endpoint, body
    it 'queries the api v2 with options' do
      url = api_v2_url + endpoint
      options = { 'zzz' => 'aaa' }
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog2.send(command, *args, options)).to eq ['200', {}]
      body = MultiJson.dump(body ? (body.merge options) : options)

      expect(WebMock).to have_requested(request, url).with(
        body: body
      )
    end
  end

  shared_examples 'an api v2 method with params' do |command, args, request, endpoint, params|
    it 'queries the api v2 with params' do
      url = api_v2_url + endpoint
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog2.send(command, *args, *params.values)).to eq ['200', {}]
      params.each { |k, v| params[k] = v.join(',') if v.is_a? Array }
      params = params

      expect(WebMock).to have_requested(request, url).with(
        query: params
      )
    end
  end

  shared_examples 'an api v2 method with optional params' do |command, args, request, endpoint, opt_params|
    include_examples 'an api v2 method', command, args, request, endpoint
    it 'queries the api v2 with optional params' do
      url = api_v2_url + endpoint
      stub_request(request, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog2.send(command, *args, opt_params)).to eq ['200', {}]
      opt_params.each { |k, v| opt_params[k] = v.join(',') if v.is_a? Array }
      params = opt_params

      expect(WebMock).to have_requested(request, url).with(
        query: params
      )
    end
  end
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # Global let
  config.include SpecDog
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
