class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.datetime :published_at
      t.references :user
      t.references :post

      t.timestamps
    end
  end
end
