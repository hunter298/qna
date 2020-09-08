class DailyDigestMailer < ApplicationMailer
  def digest(user, object)
    @object = object
    mail to: user.email
  end
end
