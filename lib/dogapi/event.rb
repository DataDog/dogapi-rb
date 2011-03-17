require 'net/http'

require 'rubygems'
require 'json'

module Dogapi

  class Event
    attr_reader :metric,
      :date_detected,
      :date_happened,
      :alert_type,
      :event_type,
      :event_object,
      :msg_title,
      :msg_text,
      :json_payload

    def initialize(msg_text, options={})
      defaults = {
        :metric => '',
        :date_detected => Time.now.to_i,
        :date_happened => Time.now.to_i,
        :alert_type => '',
        :event_type => '',
        :event_object => '',
        :msg_title => '',
        :json_payload => ''
      }
      options = defaults.merge(options)

      @msg_text = msg_text
      @metric = options[:metric]
      @date_detected = options[:date_detected]
      @date_happened = options[:date_happened]
      @alert_type = options[:alert_type]
      @event_type = options[:event_type]
      @event_object = options[:event_object]
      @msg_title = options[:msg_title]
      @json_payload = options[:json_payload]
    end
  end

  class EventService < Dogapi::Service

    def submit(api_key, event, scope=nil, source_type=nil)
      scope = scope or Dogapi::Scope.new()
      params = {
        :api_key => api_key,

        :host =>    scope.host,
        :device =>  scope.device,

        :metric =>  event.metric,
        :date_detected => event.date_detected,
        :date_happened => event.date_happened,
        :alert_type => event.alert_type,
        :event_type => event.event_type,
        :event_object => event.event_object,
        :msg_title => event.msg_title,
        :msg_text => event.msg_text,
        :json_payload => event.json_payload,
      }

      if source_type
        params[:source_type] = source_type
      end

      request Net::HTTP::Post, '/event/submit', params
    end
  end
end
