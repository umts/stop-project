Devise.setup do |config|
  require 'devise/orm/active_record'
  
  config.mailer_sender = 'stop-project@pvtaapps.com'
  config.case_insensitive_keys = [:email]
  config.secret_key = '70c47a4a4303439f42c3064ee46b19f26cd584ddec55047c45f289a2e7d6855aa3dbce0dcc6fdf84a0595dee2a79784050a7f5692195ad9e83ec966088b3fa3f'
  config.strip_whitespace_keys = [:email]
  config.stretches = Rails.env.test? ? 1 : 10
  config.sign_out_via = :delete
end
