# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'time'
require 'dogapi/v1'
require 'dogapi/v2'

module Dogapi

  # A simple DogAPI client supporting the version 2.
  #
  # See Dogapi::V2  for the thick underlying clients
  class ClientV2
    attr_accessor :datadog_host
    def initialize(api_key, application_key=nil, host=nil, device=nil, silent=true,
                   timeout=nil, endpoint=nil, skip_ssl_validation=false)

      if api_key
        @api_key = api_key
      else
        raise 'Please provide an API key to submit your data'
      end

      @application_key = application_key
      @datadog_host = endpoint || Dogapi.find_datadog_host()
      @host = host || Dogapi.find_localhost()
      @device = device

      @dashboard_list_service_v2 = Dogapi::V2::DashboardListService.new(
        @api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation
      )

    end

    def add_items_to_dashboard_list(dashboard_list_id, dashboards)
      @dashboard_list_service_v2.add_items(dashboard_list_id, dashboards)
    end

    def update_items_of_dashboard_list(dashboard_list_id, dashboards)
      @dashboard_list_service_v2.update_items(dashboard_list_id, dashboards)
    end

    def delete_items_from_dashboard_list(dashboard_list_id, dashboards)
      @dashboard_list_service_v2.delete_items(dashboard_list_id, dashboards)
    end

    def get_items_of_dashboard_list(dashboard_list_id)
      @dashboard_list_service_v2.get_items(dashboard_list_id)
    end

  end

  # A simple DogAPI client
  #
  # See Dogapi::V1  for the thick underlying clients
  #
  # Class methods return a tuple of (+response_code+, +response_body+). Unless
  # otherwise noted, the response body is deserialized JSON. Up-to-date
  # information about the JSON object structure is available in the HTTP API
  # documentation, here[https://github.com/DataDog/dogapi/wiki].
  class Client # rubocop:disable Metrics/ClassLength
    attr_accessor :datadog_host
    attr_accessor :v2
    # Support for API version 2.

    # rubocop:disable Metrics/MethodLength, Metrics/LineLength
    def initialize(api_key, application_key=nil, host=nil, device=nil, silent=true, timeout=nil, endpoint=nil, skip_ssl_validation=false)

      if api_key
        @api_key = api_key
      else
        raise 'Please provide an API key to submit your data'
      end

      @application_key = application_key
      @datadog_host = endpoint || Dogapi.find_datadog_host()
      @host = host || Dogapi.find_localhost()
      @device = device

      # FIXME: refactor to avoid all this code duplication
      @metric_svc = Dogapi::V1::MetricService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @event_svc = Dogapi::V1::EventService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @tag_svc = Dogapi::V1::TagService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @comment_svc = Dogapi::V1::CommentService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @search_svc = Dogapi::V1::SearchService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @dash_service = Dogapi::V1::DashService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @dashboard_service = Dogapi::V1::DashboardService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @dashboard_list_service = Dogapi::V1::DashboardListService.new(
        @api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation
      )
      @alert_svc = Dogapi::V1::AlertService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @user_svc = Dogapi::V1::UserService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @snapshot_svc = Dogapi::V1::SnapshotService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @embed_svc = Dogapi::V1::EmbedService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @screenboard_svc = Dogapi::V1::ScreenboardService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @monitor_svc = Dogapi::V1::MonitorService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @synthetics_svc = Dogapi::V1::SyntheticsService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @service_check_svc = Dogapi::V1::ServiceCheckService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @metadata_svc = Dogapi::V1::MetadataService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @legacy_event_svc = Dogapi::EventService.new(@datadog_host)
      @hosts_svc = Dogapi::V1::HostsService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @integration_svc = Dogapi::V1::IntegrationService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @aws_integration_svc = Dogapi::V1::AwsIntegrationService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @aws_logs_svc = Dogapi::V1::AwsLogsService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @usage_svc = Dogapi::V1::UsageService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @azure_integration_svc = Dogapi::V1::AzureIntegrationService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @gcp_integration_svc = Dogapi::V1::GcpIntegrationService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)
      @service_level_objective_svc = Dogapi::V1::ServiceLevelObjectiveService.new(@api_key, @application_key, silent,
                                                                                  timeout, @datadog_host, skip_ssl_validation)
      @logs_pipeline_svc = Dogapi::V1::LogsPipelineService.new(@api_key, @application_key, silent, timeout, @datadog_host, skip_ssl_validation)

      # Support for Dashboard List API v2.
      @v2 = Dogapi::ClientV2.new(@api_key, @application_key, true, true, @datadog_host, skip_ssl_validation)

    end
    # rubocop:enable Metrics/MethodLength, Metrics/LineLength

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
    # options[:type] = "count" to specify a counter metric
    # options[:tags] = ["tag1", "tag2"] to tag the point
    def emit_point(metric, value, options= {})
      defaults = { :timestamp => Time.now }
      options = defaults.merge(options)

      self.emit_points(
        metric,
        [[options[:timestamp], value]],
        options
      )
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
    # options[:type] = "count" to specify a counter metric
    # options[:tags] = ["tag1", "tag2"] to tag the point
    def emit_points(metric, points, options= {})
      scope = override_scope options

      points.each do |p|
        p[0].kind_of? Time or raise 'Not a Time'
        p[0] = p[0].to_i
        p[1] = p[1].to_f # TODO: stupid to_f will never raise an exception
      end

      @metric_svc.submit(metric, points, scope, options)
    end

    # Get a set of points by query between from and to
    #
    # +from+ The seconds since the unix epoch <tt>[Time, Integer]</tt>
    # +to+ The seconds since the unix epoch <tt>[Time, Integer]</tt>
    # +query+ The query string <tt>[String]</tt>
    #
    def get_points(query, from, to)
      @metric_svc.get(query, from, to)
    end

    def batch_metrics()
      @metric_svc.switch_to_batched
      begin
        yield
        @metric_svc.flush_buffer # flush_buffer should returns the response from last API call
      ensure
        @metric_svc.switch_to_single
      end
    end

    # Get a list of active metrics since a given time
    # +from+ The seconds since the unix epoch <tt>[Time, Integer]</tt>
    #
    def get_active_metrics(from)
      @metric_svc.get_active_metrics(from)
    end

    #
    # EVENTS

    # Record an event
    #
    # Optional arguments:
    #  :host        => String
    #  :device      => String
    def emit_event(event, options= {})
      scope = override_scope options

      @event_svc.post(event, scope)
    end

    # Get the details of an event
    #
    # +id+ of the event to get
    def get_event(id)
      @event_svc.get(id)
    end

    # Delete an event
    #
    # +id+ of the event to delete
    def delete_event(id)
      @event_svc.delete(id)
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
    def stream(start, stop, options= {})
      @event_svc.stream(start, stop, options)
    end

    # <b>DEPRECATED:</b> Recording events with a duration has been deprecated.
    # The functionality will be removed in a later release.
    def start_event(event, options= {})
      warn '[DEPRECATION] Dogapi::Client.start_event() is deprecated. Use `emit_event` instead.'
      defaults = { :source_type => nil }
      options = defaults.merge(options)

      scope = override_scope options

      @legacy_event_svc.start(@api_key, event, scope, options[:source_type]) do
        yield
      end
    end

    #
    # COMMENTS
    #

    # Post a comment
    def comment(message, options= {})
      @comment_svc.comment(message, options)
    end

    # Post a comment
    def update_comment(comment_id, options= {})
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
    def all_tags(source=nil)
      @tag_svc.get_all(source)
    end

    # Get all tags for the given host
    #
    # +host_id+ can be the host's numeric id or string name
    def host_tags(host_id, source=nil, by_source=false)
      @tag_svc.get(host_id, source, by_source)
    end

    # Add the tags to the given host
    #
    # +host_id+ can be the host's numeric id or string name
    #
    # +tags+ is and Array of Strings
    def add_tags(host_id, tags, source=nil)
      @tag_svc.add(host_id, tags, source)
    end

    # Replace the tags on the given host
    #
    # +host_id+ can be the host's numeric id or string name
    #
    # +tags+ is and Array of Strings
    def update_tags(host_id, tags, source=nil)
      @tag_svc.update(host_id, tags, source)
    end

    # <b>DEPRECATED:</b> Spelling mistake temporarily preserved as an alias.
    def detatch_tags(host_id)
      warn '[DEPRECATION] Dogapi::Client.detatch() is deprecated. Use `detach` instead.'
      detach_tags(host_id)
    end

    # Remove all tags from the given host
    #
    # +host_id+ can be the host's numeric id or string name
    def detach_tags(host_id, source=nil)
      @tag_svc.detach(host_id, source)
    end

    #
    # DASHES
    #

    # Create a dashboard.
    def create_dashboard(title, description, graphs, template_variables = nil, read_only = false)
      @dash_service.create_dashboard(title, description, graphs, template_variables, read_only)
    end

    # Update a dashboard.
    def update_dashboard(dash_id, title, description, graphs, template_variables = nil, read_only = false)
      @dash_service.update_dashboard(dash_id, title, description, graphs, template_variables, read_only)
    end

    # Fetch the given dashboard.
    def get_dashboard(dash_id)
      @dash_service.get_dashboard(dash_id)
    end

    # Fetch all of the dashboards.
    def get_dashboards
      @dash_service.get_dashboards
    end

    # Delete the given dashboard.
    def delete_dashboard(dash_id)
      @dash_service.delete_dashboard(dash_id)
    end

    #
    # DASHBOARDS
    #

    # Create a dashboard.
    def create_board(title, widgets, layout_type, options= {})
      @dashboard_service.create_board(title, widgets, layout_type, options)
    end

    # Update a dashboard.
    def update_board(dashboard_id, title, widgets, layout_type, options= {})
      @dashboard_service.update_board(dashboard_id, title, widgets, layout_type, options)
    end

    # Fetch the given dashboard.
    def get_board(dashboard_id)
      @dashboard_service.get_board(dashboard_id)
    end

    # Fetch all dashboards.
    def get_all_boards()
      @dashboard_service.get_all_boards()
    end

    # Delete the given dashboard.
    def delete_board(dashboard_id)
      @dashboard_service.delete_board(dashboard_id)
    end

    #
    # DASHBOARD LISTS
    #

    def create_dashboard_list(name)
      @dashboard_list_service.create(name)
    end

    def update_dashboard_list(dashboard_list_id, name)
      @dashboard_list_service.update(dashboard_list_id, name)
    end

    def get_dashboard_list(dashboard_list_id)
      @dashboard_list_service.get(dashboard_list_id)
    end

    def get_all_dashboard_lists()
      @dashboard_list_service.all()
    end

    def delete_dashboard_list(dashboard_list_id)
      @dashboard_list_service.delete(dashboard_list_id)
    end

    def add_items_to_dashboard_list(dashboard_list_id, dashboards)
      @dashboard_list_service.add_items(dashboard_list_id, dashboards)
    end

    def update_items_of_dashboard_list(dashboard_list_id, dashboards)
      @dashboard_list_service.update_items(dashboard_list_id, dashboards)
    end

    def delete_items_from_dashboard_list(dashboard_list_id, dashboards)
      @dashboard_list_service.delete_items(dashboard_list_id, dashboards)
    end

    def get_items_of_dashboard_list(dashboard_list_id)
      @dashboard_list_service.get_items(dashboard_list_id)
    end

    #
    # ALERTS
    #

    def alert(query, options= {})
      @alert_svc.alert(query, options)
    end

    def update_alert(alert_id, query, options= {})
      @alert_svc.update_alert(alert_id, query, options)
    end

    def get_alert(alert_id)
      @alert_svc.get_alert(alert_id)
    end

    def delete_alert(alert_id)
      @alert_svc.delete_alert(alert_id)
    end

    def get_all_alerts()
      @alert_svc.get_all_alerts()
    end

    def mute_alerts()
      @alert_svc.mute_alerts()
    end

    def unmute_alerts()
      @alert_svc.unmute_alerts()
    end

    # User invite
    def invite(emails, options= {})
      @user_svc.invite(emails, options)
    end

    def create_user(description= {})
      @user_svc.create_user(description)
    end

    def get_all_users()
      @user_svc.get_all_users()
    end

    def get_user(handle)
      @user_svc.get_user(handle)
    end

    def update_user(handle, description= {})
      @user_svc.update_user(handle, description)
    end

    def disable_user(handle)
      @user_svc.disable_user(handle)
    end

    # Graph snapshot
    def graph_snapshot(metric_query, start_ts, end_ts, event_query=nil)
      @snapshot_svc.snapshot(metric_query, start_ts, end_ts, event_query)
    end

    #
    # EMBEDS
    #
    def get_all_embeds()
      @embed_svc.get_all_embeds()
    end

    def get_embed(embed_id, description= {})
      @embed_svc.get_embed(embed_id, description)
    end

    def create_embed(graph_json, description= {})
      @embed_svc.create_embed(graph_json, description)
    end

    def enable_embed(embed_id)
      @embed_svc.enable_embed(embed_id)
    end

    def revoke_embed(embed_id)
      @embed_svc.revoke_embed(embed_id)
    end

    #
    # SCREENBOARD
    #
    def create_screenboard(description)
      @screenboard_svc.create_screenboard(description)
    end

    def update_screenboard(board_id, description)
      @screenboard_svc.update_screenboard(board_id, description)
    end

    def get_screenboard(board_id)
      @screenboard_svc.get_screenboard(board_id)
    end

    def get_all_screenboards()
      @screenboard_svc.get_all_screenboards()
    end

    def delete_screenboard(board_id)
      @screenboard_svc.delete_screenboard(board_id)
    end

    def share_screenboard(board_id)
      @screenboard_svc.share_screenboard(board_id)
    end

    def revoke_screenboard(board_id)
      @screenboard_svc.revoke_screenboard(board_id)
    end

    #
    # SYNTHETICS
    #
    def create_synthetics_test(type, config, options = {})
      @synthetics_svc.create_synthetics_test(type, config, options)
    end

    def update_synthetics_test(test_id, type, config, options = {})
      @synthetics_svc.update_synthetics_test(test_id, type, config, options)
    end

    def delete_synthetics_tests(test_ids)
      @synthetics_svc.delete_synthetics_tests(test_ids)
    end

    def start_pause_synthetics_test(test_id, new_status)
      @synthetics_svc.start_pause_synthetics_test(test_id, new_status)
    end

    def get_all_synthetics_tests
      @synthetics_svc.get_all_synthetics_tests()
    end

    def get_synthetics_test(test_id)
      @synthetics_svc.get_synthetics_test(test_id)
    end

    def get_synthetics_results(test_id)
      @synthetics_svc.get_synthetics_results(test_id)
    end

    def get_synthetics_result(test_id, result_id)
      @synthetics_svc.get_synthetics_result(test_id, result_id)
    end

    def get_synthetics_devices
      @synthetics_svc.get_synthetics_devices()
    end

    def get_synthetics_locations
      @synthetics_svc.get_synthetics_locations()
    end

    #
    # MONITORS
    #

    def monitor(type, query, options= {})
      @monitor_svc.monitor(type, query, options)
    end

    def update_monitor(monitor_id, query, options= {})
      @monitor_svc.update_monitor(monitor_id, query, options)
    end

    def get_monitor(monitor_id, options= {})
      @monitor_svc.get_monitor(monitor_id, options)
    end

    def can_delete_monitors(monitor_ids)
      @monitor_svc.can_delete_monitors(monitor_ids)
    end

    def delete_monitor(monitor_id, options = {})
      @monitor_svc.delete_monitor(monitor_id, options)
    end

    def get_all_monitors(options= {})
      @monitor_svc.get_all_monitors(options)
    end

    def validate_monitor(type, query, options= {})
      @monitor_svc.validate_monitor(type, query, options)
    end

    def mute_monitors()
      @monitor_svc.mute_monitors()
    end

    def unmute_monitors()
      @monitor_svc.unmute_monitors()
    end

    def mute_monitor(monitor_id, options= {})
      @monitor_svc.mute_monitor(monitor_id, options)
    end

    def unmute_monitor(monitor_id, options= {})
      @monitor_svc.unmute_monitor(monitor_id, options)
    end

    def resolve_monitors(monitor_groups = [], options = {}, version = nil)
      @monitor_svc.resolve_monitors(monitor_groups, options, version)
    end

    def search_monitors(options = {})
      @monitor_svc.search_monitors(options)
    end

    def search_monitor_groups(options = {})
      @monitor_svc.search_monitor_groups(options)
    end

    #
    # MONITOR DOWNTIME
    #

    def schedule_downtime(scope, options= {})
      @monitor_svc.schedule_downtime(scope, options)
    end

    def update_downtime(downtime_id, options= {})
      @monitor_svc.update_downtime(downtime_id, options)
    end

    def get_downtime(downtime_id, options = {})
      @monitor_svc.get_downtime(downtime_id, options)
    end

    def cancel_downtime(downtime_id)
      @monitor_svc.cancel_downtime(downtime_id)
    end

    def cancel_downtime_by_scope(scope)
      @monitor_svc.cancel_downtime_by_scope(scope)
    end

    def get_all_downtimes(options= {})
      @monitor_svc.get_all_downtimes(options)
    end

    #
    # HOST MUTING
    #

    def mute_host(hostname, options= {})
      @monitor_svc.mute_host(hostname, options)
    end

    def unmute_host(hostname)
      @monitor_svc.unmute_host(hostname)
    end

    #
    # SERVICE LEVEL OBJECTIVES
    #

    def create_service_level_objective(type, slo_name, thresholds, options = {})
      @service_level_objective_svc.create_service_level_objective(type, slo_name, thresholds, options)
    end

    def update_service_level_objective(slo_id, type, options = {})
      @service_level_objective_svc.update_service_level_objective(slo_id, type, options)
    end

    def get_service_level_objective(slo_id)
      @service_level_objective_svc.get_service_level_objective(slo_id)
    end

    def get_service_level_objective_history(slo_id, from_ts, to_ts)
      @service_level_objective_svc.get_service_level_objective_history(slo_id, from_ts, to_ts)
    end

    def search_service_level_objective(slo_ids = nil, query = nil, offset = nil, limit = nil)
      @service_level_objective_svc.search_service_level_objective(slo_ids, query, offset, limit)
    end

    def can_delete_service_level_objective(slo_ids)
      @service_level_objective_svc.can_delete_service_level_objective(slo_ids)
    end

    def delete_service_level_objective(slo_id)
      @service_level_objective_svc.delete_service_level_objective(slo_id)
    end

    def delete_many_service_level_objective(slo_ids)
      @service_level_objective_svc.delete_many_service_level_objective(slo_ids)
    end

    def delete_timeframes_service_level_objective(ops)
      @service_level_objective_svc.delete_timeframes_service_level_objective(ops)
    end

    #
    # LOGS PIPELINES
    #

    def create_logs_pipeline(name, filter, options = {})
      @logs_pipeline_svc.create_logs_pipeline(name, filter, options)
    end

    def get_logs_pipeline(pipeline_id)
      @logs_pipeline_svc.get_logs_pipeline(pipeline_id)
    end

    def get_all_logs_pipelines
      @logs_pipeline_svc.get_all_logs_pipelines
    end

    def update_logs_pipeline(pipeline_id, name, filter, options = {})
      @logs_pipeline_svc.update_logs_pipeline(pipeline_id, name, filter, options)
    end

    def delete_logs_pipeline(pipeline_id)
      @logs_pipeline_svc.delete_logs_pipeline(pipeline_id)
    end

    #
    # SERVICE CHECKS
    #

    def service_check(check, host, status, options= {})
      @service_check_svc.service_check(check, host, status, options)
    end

    #
    # METADATA
    #

    # Get metadata information on an existing Datadog metric
    def get_metadata(metric)
      @metadata_svc.get(metric)
    end

    # Update metadata fields for an existing Datadog metric.
    # If the metadata does not exist for the metric it is created by
    # the update.
    # Optional arguments:
    #   :type             => String, type of the metric (ex. "gauge", "rate", etc.)
    #                        see http://docs.datadoghq.com/metrictypes/
    #   :description      => String, description of the metric
    #   :short_name       => String, short name of the metric
    #   :unit             => String, unit type associated with the metric (ex. "byte", "operation")
    #                        see http://docs.datadoghq.com/units/ for full list
    #   :per_unit         => String, per unit type (ex. "second" as in "queries per second")
    #                        see http://docs.datadoghq.com/units/ for full
    #   :statsd_interval  => Integer, statsd flush interval for metric in seconds (if applicable)
    def update_metadata(metric, options= {})
      @metadata_svc.update(metric, options)
    end

    #
    # HOSTS
    #

    def search_hosts(options = {})
      @hosts_svc.search(options)
    end

    def host_totals()
      @hosts_svc.totals()
    end

    #
    # INTEGRATIONS
    #

    def create_integration(source_type_name, config)
      @integration_svc.create_integration(source_type_name, config)
    end

    def update_integration(source_type_name, config)
      @integration_svc.update_integration(source_type_name, config)
    end

    def get_integration(source_type_name)
      @integration_svc.get_integration(source_type_name)
    end

    def delete_integration(source_type_name)
      @integration_svc.delete_integration(source_type_name)
    end

    #
    # AWS INTEGRATION
    #
    def aws_integration_list
      @aws_integration_svc.aws_integration_list
    end

    def aws_integration_create(config)
      @aws_integration_svc.aws_integration_create(config)
    end

    def aws_integration_delete(config)
      @aws_integration_svc.aws_integration_delete(config)
    end

    def aws_integration_list_namespaces
      @aws_integration_svc.aws_integration_list_namespaces
    end

    def aws_integration_generate_external_id(config)
      @aws_integration_svc.aws_integration_generate_external_id(config)
    end

    def aws_integration_update(config, new_config)
      @aws_integration_svc.aws_integration_update(config, new_config)
    end

    #
    # AWS Logs Integration
    #

    def aws_logs_add_lambda(config)
      @aws_logs_svc.aws_logs_add_lambda(config)
    end

    def aws_logs_list_services
      @aws_logs_svc.aws_logs_list_services
    end

    def aws_logs_save_services(config)
      @aws_logs_svc.aws_logs_save_services(config)
    end

    def aws_logs_integrations_list
      @aws_logs_svc.aws_logs_integrations_list
    end

    def aws_logs_integration_delete(config)
      @aws_logs_svc.aws_logs_integration_delete(config)
    end

    def aws_logs_check_lambda(config)
      @aws_logs_svc.aws_logs_check_lambda(config)
    end

    def aws_logs_check_services(config)
      @aws_logs_svc.aws_logs_check_services(config)
    end

    #
    # AZURE INTEGRATION
    #

    def azure_integration_list
      @azure_integration_svc.azure_integration_list
    end

    def azure_integration_create(config)
      @azure_integration_svc.azure_integration_create(config)
    end

    def azure_integration_delete(config)
      @azure_integration_svc.azure_integration_delete(config)
    end

    def azure_integration_update_host_filters(config)
      @azure_integration_svc.azure_integration_update_host_filters(config)
    end

    def azure_integration_update(config)
      @azure_integration_svc.azure_integration_update(config)
    end

    #
    # GCP INTEGRATION
    #
    def gcp_integration_list
      @gcp_integration_svc.gcp_integration_list
    end

    def gcp_integration_delete(config)
      @gcp_integration_svc.gcp_integration_delete(config)
    end

    def gcp_integration_create(config)
      @gcp_integration_svc.gcp_integration_create(config)
    end

    def gcp_integration_update(config)
      @gcp_integration_svc.gcp_integration_update(config)
    end

    #
    # USAGE
    #

    # Get hourly usage information for different datadog service
    # Usage data is delayed by up to 72 hours from when it was incurred. It is retained for the past 15 months.#
    # format of dates is ISO-8601 UTC YYYY-MM-DDThh
    # ex:
    #   require 'time'
    #   Time.now.utc.strftime('%Y-%m-%dT%H')
    # => "2019-05-05T13"
    def get_hosts_usage(start_hr, end_hr = nil)
      @usage_svc.get_hosts_usage(start_hr, end_hr)
    end

    def get_logs_usage(start_hr, end_hr = nil)
      @usage_svc.get_logs_usage(start_hr, end_hr)
    end

    def get_custom_metrics_usage(start_hr, end_hr = nil)
      @usage_svc.get_custom_metrics_usage(start_hr, end_hr)
    end

    def get_traces_usage(start_hr, end_hr = nil)
      @usage_svc.get_traces_usage(start_hr, end_hr)
    end

    def get_synthetics_usage(start_hr, end_hr = nil)
      @usage_svc.get_synthetics_usage(start_hr, end_hr)
    end

    def get_fargate_usage(start_hr, end_hr = nil)
      @usage_svc.get_fargate_usage(start_hr, end_hr)
    end

    private

    def override_scope(options= {})
      defaults = { :host => @host, :device => @device }
      options = defaults.merge(options)
      Scope.new(options[:host], options[:device])
    end
  end
end
