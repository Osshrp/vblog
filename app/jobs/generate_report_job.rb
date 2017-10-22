class GenerateReportJob < ApplicationJob
  queue_as :default

  def perform(start_date, end_date, email)
    users = User.count_users_posts_or_comments(start_date, end_date).as_json
    ReportMailer.perform(email, users).deliver_now
  end
end
