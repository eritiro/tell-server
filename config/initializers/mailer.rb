mailing_config = APP_CONFIG['mailing']

ActionMailer::Base.mailgun_settings = {
  api_key: mailing_config['api_key'],
  domain: mailing_config['domain']
}

ActionMailer::Base.default_url_options = { :host => APP_CONFIG['host'] }
ActionMailer::Base.asset_host = "http://#{APP_CONFIG['host']}"