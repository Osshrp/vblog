class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :author_nickname
  has_many :comments

  def author_nickname
    object.user.nickname
  end
end
