require 'time'
require 'dogapi/metric'

module Dogapi

  class Client

    def initialize(api_key, host=nil, device=nil)

      if api_key
        @api_key = api_key
      else
        raise 'Please provide an API key to submit your data'
      end

      @datadog_host = Dogapi.find_datadog_host()
      if !@datadog_host
        raise 'DATADOG_HOST env variable not set'
      end

      @host = host
      @device = device

      @metric_svc = Dogapi::MetricService.new(@datadog_host)
      @event_svc = Dogapi::EventService.new(@datadog_host)
    end

    def emit_point(metric, value, options={})
      defaults = {:timestamp => Time.now, :host => nil, :device => nil}
      options = defaults.merge(options)

      self.emit_points metric,
                       [[options[:timestamp], value]],
                       :host => options[:host],
                       :device => options[:device]
    end

    def emit_points(metric, points, options={})
      defaults = {:host => nil, :device => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      points.each do |p|
        p[0].kind_of? Time or raise "Not a Time"
        p[1].to_f # TODO: stupid to_f will never raise and exception
      end

      @metric_svc.submit @api_key, scope, metric, points
    end

    def emit_event(event, options={})
      defaults = {:host => nil, :device => nil, :source_type => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      @event_svc.submit(@api_key, event, scope, options[:source_type])
    end

    def start_event(event, options={})
      defaults = {:host => nil, :device => nil, :source_type => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      @event_svc.start(@api_key, event, scope, options[:source_type]) do
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

  def Dogapi.init(api_key, host=nil, device=nil)
    Client.new(api_key, host, device)
  end
end
