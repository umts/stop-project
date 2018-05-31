Devise.setup do |config|
  require 'devise/orm/active_record'
  
  config.mailer_sender = 'stop-project@pvtaapps.com'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.stretches = Rails.env.test? ? 1 : 10
  config.sign_out_via = :delete
end
