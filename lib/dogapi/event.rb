# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'net/http'

require 'rubygems'
require 'multi_json'

module Dogapi

  # Metadata class for storing the details of an event
  class Event
    attr_reader :date_happened,
      :msg_title,
      :msg_text,
      :priority,
      :parent,
      :tags,
      :aggregation_key

  # Optional arguments:
  #  :date_happened => time in seconds since the epoch (defaults to now)
  #  :msg_title     => String
  #  :priority      => String
  #  :parent        => event ID (integer)
  #  :tags          => array of Strings
  #  :event_object  => String
  #  :alert_type    => 'success', 'error'
  #  :event_type    => String
  #  :source_type_name => String
  #  :aggregation_key => String
    def initialize(msg_text, options= {})
      defaults = {
        :date_happened => Time.now.to_i,
        :msg_title => '',
        :priority => "normal",
        :parent => nil,
        :tags => [],
        :aggregation_key => nil
      }
      options = defaults.merge(options)

      @msg_text = msg_text
      @date_happened = options[:date_happened]
      @msg_title = options[:msg_title]
      @priority = options[:priority]
      @parent = options[:parent]
      @tags = options[:tags]
      @aggregation_key = options[:event_object] || options[:aggregation_key]
      @alert_type = options[:alert_type]
      @event_type = options[:event_type]
      @source_type_name = options[:source_type_name]
    end

    # Copy and pasted from the internets
    # http://stackoverflow.com/a/5031637/25276
    def to_hash
      hash = {}
      instance_variables.each { |var| hash[var.to_s[1..-1].to_sym] = instance_variable_get(var) }
      hash
    end
  end

  # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
  # removed in an upcoming release.
  class EventService < Dogapi::Service

    API_VERSION = '1.0.0'
    MAX_BODY_LENGTH = 4000
    MAX_TITLE_LENGTH = 100

    # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
    # removed in an upcoming release.
    def submit(api_key, event, scope=nil, source_type=nil)
      warn '[DEPRECATION] Dogapi::EventService.submit() has been deprecated in favor of the newer V1 services'
      scope = scope || Dogapi::Scope.new()
      params = {
        :api_key => api_key,
        :api_version  =>  API_VERSION,

        :host =>    scope.host,
        :device =>  scope.device,

        :metric =>  event.metric,
        :date_detected => event.date_detected,
        :date_happened => event.date_happened,
        :alert_type => event.alert_type,
        :event_type => event.event_type,
        :event_object => event.event_object,
        :msg_title => event.msg_title[0..MAX_TITLE_LENGTH - 1],
        :msg_text => event.msg_text[0..MAX_BODY_LENGTH - 1],
        :json_payload => event.json_payload,
      }

      if source_type
        params[:source_type] = source_type
      end

      request Net::HTTP::Post, '/event/submit', params
    end

    # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
    # removed in an upcoming release.
    def start(api_key, event, scope, source_type=nil)
      warn '[DEPRECATION] Dogapi::EventService.start() has been deprecated in favor of the newer V1 services'
      response = submit api_key, event, scope, source_type
      success = nil

      begin
        yield response
      rescue
        success = false
        raise
      else
        success = true
      ensure
        return finish api_key, response['id'], success
      end
    end

    private

    def finish(api_key, event_id, successful=nil)
      params = {
        :api_key => api_key,
        :event_id => event_id
      }

      request Net::HTTP::Post, '/event/ended', params
    end
  end
end
