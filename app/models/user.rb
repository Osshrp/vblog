class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :comments

  validates :nickname, presence: true

  mount_uploader :avatar, AvatarUploader

  scope :count_users_posts_or_comments, ->(start_date, end_date) {
    left_joins(:posts, :comments).select('users.id, users.nickname, users.email,
      count(distinct comments.id) as comments_count,
      count(distinct posts.id) as posts_count,
      (count(distinct comments.id) + count(distinct posts.id))/10.0 as ratio')
      .where('posts.published_at between ? and ? or comments.published_at between ? and ?',
      start_date, end_date, start_date, end_date).group('users.id').order('ratio DESC') }
end
