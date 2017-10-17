class AddIndexToPosts < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, :published_at
    add_index :comments, :published_at
  end
end
