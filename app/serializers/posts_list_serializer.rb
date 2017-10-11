class PostsListSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :published_at, :created_at, :updated_at
  has_many :comments
end
