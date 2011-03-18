require 'net/http'

require 'rubygems'
require 'json'

module Dogapi

  # Metadata class for storing the details of an event
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

  # Optional arguments:
  #  :metric        => String
  #  :date_detected => time in seconds since the epoch (defaults to now)
  #  :date_happened => time in seconds since the epoch (defaults to now)
  #  :alert_type    => String
  #  :event_type    => String
  #  :event_object  => String
  #  :msg_title     => String
  #  :json_payload  => String
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

  # Event-specific client affording more granular control than the simple Dogapi::Client
  class EventService < Dogapi::Service

    API_VERSION = "1.0.0"

    # Records an Event with no duration
    def submit(api_key, event, scope=nil, source_type=nil)
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
        :msg_title => event.msg_title,
        :msg_text => event.msg_text,
        :json_payload => event.json_payload,
      }

      if source_type
        params[:source_type] = source_type
      end

      request Net::HTTP::Post, '/event/submit', params
    end

    # Manages recording an event with a duration
    #
    # 0. The start time is recorded immediately
    # 0. The given block is executed with access to the response of the start request
    # 0. The end time is recorded once the block completes execution
    def start(api_key, event, scope, source_type=nil)
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
