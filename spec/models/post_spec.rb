require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  let(:post) { create(:post, published_at: nil) }


  describe '#author_nickname' do
    it 'returns author nickname' do
      expect(post.author_nickname).to eq(post.user.nickname)
    end
  end
end
