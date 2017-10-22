require 'rails_helper'

RSpec.describe GenerateReportJob, type: :job do
  let(:start_date) { 1.month.ago }
  let(:end_date) { Date.today }

  it 'generates report' do
    expect(User).to receive(:count_users_posts_or_comments).with(start_date, end_date)
    GenerateReportJob.perform_now(start_date, end_date, 'test@test.com')
  end

  it 'sends report'
end
