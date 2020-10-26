ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  user_name: Rails.application.credentials.production[:smtp][:SMTP_USERNAME],
  password: Rails.application.credentials.production[:smtp][:SMTP_PASSWORD],
  authentication: :plain,
  enable_starttls_auto: true
}
