Sentry.init do |config|
  config.dsn = "https://20ecca0bf0fa4feba9da4ef12447f489@o4509484975849472.ingest.de.sentry.io/4509484977422416"
  # get breadcrumbs from logs
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

  # Add data like request headers and IP for users, if applicable;
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
end
