require 'time'
require 'dogapi/v1'

module Dogapi

  # A simple DogAPI client
  #
  # See Dogapi::EventService and Dogapi::MetricService for the thick underlying clients
  class Client

    # Create a new Client optionally specifying a default host and device
    def initialize(api_key, application_key=nil, host=nil, device=nil)

      if api_key
        @api_key = api_key
      else
        raise 'Please provide an API key to submit your data'
      end

      @application_key = application_key

      @datadog_host = Dogapi.find_datadog_host()

      @host = host
      @device = device

      @metric_svc = Dogapi::V1::MetricService.new(@api_key, @application_key)
      @event_svc = Dogapi::V1::EventService.new(@api_key, @application_key)
      @legacy_event_svc = Dogapi::EventService.new(@datadog_host)
    end

    # Record a single point of metric data
    #
    # Optional arguments:
    #  :timestamp => Ruby stdlib Time
    #  :host      => String
    #  :device    => String
    def emit_point(metric, value, options={})
      defaults = {:timestamp => Time.now, :host => nil, :device => nil}
      options = defaults.merge(options)

      self.emit_points(metric,
                       [[options[:timestamp], value]],
                       :host => options[:host],
                       :device => options[:device])
    end

    # Record a set of points of metric data
    #
    # +points+ is an array of <tt>[Time, value]</tt> doubles
    #
    # Optional arguments:
    #  :host   => String
    #  :device => String
    def emit_points(metric, points, options={})
      defaults = {:host => nil, :device => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      points.each do |p|
        p[0].kind_of? Time or raise "Not a Time"
        p[0] = p[0].to_i
        p[1] = p[1].to_f # TODO: stupid to_f will never raise an exception
      end

      @metric_svc.submit(metric, points, scope)
    end

    # Record an event
    #
    # Optional arguments:
    #  :host        => String
    #  :device      => String
    def emit_event(event, options={})
      defaults = {:host => nil, :device => nil}
      options = defaults.merge(options)

      scope = override_scope(options[:host], options[:device])

      @event_svc.submit(event, scope)
    end

    # DEPRECATED
    def start_event(event, options={})
      defaults = {:host => nil, :device => nil, :source_type => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      @legacy_event_svc.start(@api_key, event, scope, options[:source_type]) do
        yield
      end
    end

    private

    def override_scope(host, device)
      if host
        h = host
      else
        h = @host
      end
      if device
        d = device
      else
        d = @device
      end
      Scope.new(h, d)
    end
  end
end
