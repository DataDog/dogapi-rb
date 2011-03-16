require 'socket'

def find_datadog_host
  ENV['DATADOG_HOST'] rescue nil
end

def find_api_key
  ENV['DATADOG_KEY'] rescue nil
end

def find_localhost
  Socket.gethostname
end
