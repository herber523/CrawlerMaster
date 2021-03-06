Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)

    extra_logs = {
      params:     event.payload[:params].except(*exceptions),
      remote_ip:  event.payload[:remote_ip],
      user_agent: event.payload[:user_agent],
      time:       event.time,
      host:       Socket.gethostname
    }

    extra_logs
  end

  if Rails.env.production? || Rails.env.staging?
    config.lograge.formatter = Lograge::Formatters::Json.new
  end

end
