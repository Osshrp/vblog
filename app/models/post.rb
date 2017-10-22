class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, :body, presence: true

  scope :desc_order, -> { order(published_at: :desc) }

  def author_nickname
    user.nickname
  end
end
