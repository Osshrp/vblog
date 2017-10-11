class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, :body, presence: true

  def author_nickname
    user.nickname
  end

  # def set_published_at
  #   self.published_at = Time.zone.now
  #   save
  # end
end
