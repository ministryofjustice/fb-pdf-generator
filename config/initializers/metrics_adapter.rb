require 'metrics_adapter/rails'

MetricsAdapter.configure do |config|
  config.adapter = :mixpanel
  config.adapter_options = {
    secret: ENV['METRICS_ACCESS_KEY']
  }
  config.extra_attributes = { app: 'PDF Generator' }
  config.logger = Rails.logger
  config.trackers = %i[slow_request]
  config.thresholds = { slow_request: 1_000 }

  ## Only send metrics if is production
  ##
  block = -> { ENV['HOSTNAME'].to_s.include?('live-production') }
  config.conditionals = { slow_request: block }
end
