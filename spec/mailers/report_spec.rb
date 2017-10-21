require "rails_helper"

RSpec.describe ReportMailer, type: :mailer do
  describe "perform" do
    let(:user)  { create(:user) }
    let!(:posts) { create_list(:post, 12, user: user) }
    let!(:coments) { create_list(:comment, 19, post: posts.first, user: user) }
    let(:start_date) { 1.day.ago.to_date }
    let(:end_date) { Date.today.to_date }
    let(:users) { User.count_users_posts_or_comments(start_date, end_date).as_json }
    let(:mail) { ReportMailer.perform('test@test.com', users) }

    it "renders the headers" do
      expect(mail.subject).to eq('Analitic report')
      expect(mail.to).to eq(['test@test.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.email)
      expect(mail.body.encoded).to have_content(user.posts.count)
      expect(mail.body.encoded).to have_content(user.comments.count)
    end
  end
end
