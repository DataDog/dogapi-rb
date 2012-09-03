require 'time'
require 'dogapi/v1'

module Dogapi

  # A simple DogAPI client
  #
  # See Dogapi::V1  for the thick underlying clients
  #
  # Class methods return a tuple of (+response_code+, +response_body+). Unless otherwise noted, the response body is deserialized JSON. Up-to-date information about the JSON object structure is available in the HTTP API documentation, here[https://github.com/DataDog/dogapi/wiki].
  class Client

    # Create a new Client optionally specifying a default host and device
    def initialize(api_key, application_key=nil, host=nil, device=nil, silent=true)

      if api_key
        @api_key = api_key
      else
        raise 'Please provide an API key to submit your data'
      end

      @application_key = application_key

      @datadog_host = Dogapi.find_datadog_host()

      @host = host
      @device = device

      @metric_svc = Dogapi::V1::MetricService.new(@api_key, @application_key, silent)
      @event_svc = Dogapi::V1::EventService.new(@api_key, @application_key, silent)
      @tag_svc = Dogapi::V1::TagService.new(@api_key, @application_key, silent)
      @comment_svc = Dogapi::V1::CommentService.new(@api_key, @application_key, silent)
      @search_svc = Dogapi::V1::SearchService.new(@api_key, @application_key, silent)
      @dash_service = Dogapi::V1::DashService.new(@api_key, @application_key, silent)

      @legacy_event_svc = Dogapi::EventService.new(@datadog_host)
    end

    #
    # METRICS

    # Record a single point of metric data
    #
    # Optional arguments:
    #  :timestamp => Ruby stdlib Time
    #  :host      => String
    #  :device    => String
    #  :options   => Map
    #
    # options[:type] = "counter" to specify a counter metric
    # options[:tags] = ["tag1", "tag2"] to tag the point
    def emit_point(metric, value, options={})
      defaults = {:timestamp => Time.now, :host => nil, :device => nil}
      options = defaults.merge(options)

      self.emit_points(metric,
                       [[options[:timestamp], value]],
                       options)
    end

    # Record a set of points of metric data
    #
    # +points+ is an array of <tt>[Time, value]</tt> doubles
    #
    # Optional arguments:
    #  :host   => String
    #  :device => String
    #  :options   => Map
    #
    # options[:type] = "counter" to specify a counter metric
    # options[:tags] = ["tag1", "tag2"] to tag the point
    def emit_points(metric, points, options={})
      defaults = {:host => nil, :device => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      points.each do |p|
        p[0].kind_of? Time or raise "Not a Time"
        p[0] = p[0].to_i
        p[1] = p[1].to_f # TODO: stupid to_f will never raise an exception
      end

      @metric_svc.submit(metric, points, scope, options)
    end

    #
    # EVENTS

    # Record an event
    #
    # Optional arguments:
    #  :host        => String
    #  :device      => String
    def emit_event(event, options={})
      defaults = {:host => nil, :device => nil}
      options = defaults.merge(options)

      scope = override_scope(options[:host], options[:device])

      @event_svc.post(event, scope)
    end

    # Get the details of an event
    #
    # +id+ of the event to get
    def get_event(id)
      @event_svc.get(id)
    end

    # Get an optionally filtered event stream
    #
    # +start+ is a Time object for when to start the stream
    #
    # +stop+ is a Time object for when to end the stream
    #
    # Optional arguments:
    #   :priority   => "normal" or "low"
    #   :sources    => String, see https://github.com/DataDog/dogapi/wiki/Event for a current list of sources
    #   :tags       => Array of Strings
    def stream(start, stop, options={})
      @event_svc.stream(start, stop, options)
    end

    # <b>DEPRECATED:</b> Recording events with a duration has been deprecated.
    # The functionality will be removed in a later release.
    def start_event(event, options={})
      warn "[DEPRECATION] Dogapi::Client.start_event() is deprecated. Use `emit_event` instead."
      defaults = {:host => nil, :device => nil, :source_type => nil}
      options = defaults.merge(options)

      scope = override_scope options[:host], options[:device]

      @legacy_event_svc.start(@api_key, event, scope, options[:source_type]) do
        yield
      end
    end

    #
    # COMMENTS
    #

    # Post a comment
    def comment(message, options={})
      @comment_svc.comment(message, options)
    end

    # Post a comment
    def update_comment(comment_id, options={})
      @comment_svc.update_comment(comment_id, options)
    end

    def delete_comment(comment_id)
      @comment_svc.delete_comment(comment_id)
    end

    #
    # SEARCH
    #

    # Run the given search query.
    def search(query)
      @search_svc.search query
    end


    #
    # TAGS
    #

    # Get all tags and their associated hosts at your org
    def all_tags()
      @tag_svc.get_all()
    end

    # Get all tags for the given host
    #
    # +host_id+ can be the host's numeric id or string name
    def host_tags(host_id)
      @tag_svc.get(host_id)
    end

    # Add the tags to the given host
    #
    # +host_id+ can be the host's numeric id or string name
    #
    # +tags+ is and Array of Strings
    def add_tags(host_id, tags)
      @tag_svc.add(host_id, tags)
    end

    # Replace the tags on the given host
    #
    # +host_id+ can be the host's numeric id or string name
    #
    # +tags+ is and Array of Strings
    def update_tags(host_id, tags)
      @tag_svc.update(host_id, tags)
    end

    # <b>DEPRECATED:</b> Spelling mistake temporarily preserved as an alias.
    def detatch_tags(host_id)
      warn "[DEPRECATION] Dogapi::Client.detatch() is deprecated. Use `detach` instead."
      detach_tags(host_id)
    end

    # Remove all tags from the given host
    #
    # +host_id+ can be the host's numeric id or string name
    def detach_tags(host_id)
      @tag_svc.detach(host_id)
    end

    #
    # DASHES
    #

    # Create a dashboard.
    def create_dashboard(title, description, graphs)
      @dash_service.create_dashboard(title, description, graphs)
    end

    # Update a dashboard.
    def update_dashboard(dash_id, title, description, graphs)
      @dash_service.update_dashboard(dash_id, title, description, graphs)
    end

    # Fetch the given dashboard.
    def get_dashboard(dash_id)
      @dash_service.get_dashboard(dash_id)
    end

    # Delete the given dashboard.
    def delete_dashboard(dash_id)
      @dash_service.delete_dashboard(dash_id)
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
