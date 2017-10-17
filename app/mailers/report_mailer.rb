class ReportMailer < ApplicationMailer
  def perform(email, users)
    @users = users
    mail(to: email, subject: 'Analitic report')
  end
end
