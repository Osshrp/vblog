require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:posts) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:nickname) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user1_posts) { create_list(:post, 10, user: user1) }
  let!(:user2_posts) { create_list(:post, 5, user: user2) }
  let!(:user1_comments) { create_list(:comment, 11, post: user2_posts.first, user: user1) }
  let!(:user3_posts) { create_list(:post, 25, user: user3) }

  describe '.count_users_posts_or_comments' do

    it 'should return users nickname' do
      expect(User.count_users_posts_or_comments(1.month.ago, Date.today).second.nickname)
        .to eq(user1.nickname)
    end

    it 'should return users email' do
      expect(User.count_users_posts_or_comments(1.month.ago, Date.today).second.email)
        .to eq(user1.email)
    end

    it 'should return users posts amount' do
      expect(User.count_users_posts_or_comments(1.month.ago, Date.today).second.posts_count)
        .to eq(10)
    end

    it 'should return users comments amount' do
      expect(User.count_users_posts_or_comments(1.month.ago, Date.today).second.comments_count)
        .to eq(11)
    end

    it 'should return users with max amount of posts + comments in first place' do
      expect(User.count_users_posts_or_comments(1.month.ago, Date.today).first).to eq(user3)
    end
  end
end
