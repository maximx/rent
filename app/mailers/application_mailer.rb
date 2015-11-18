class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@rent.com"
  layout 'mailer'
end
