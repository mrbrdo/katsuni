class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.string :email
      t.text :comment
      t.string :password
      t.string :photo
      t.references :post
      t.references :board

      t.timestamps
    end
    add_index :posts, :post_id
    add_index :posts, :board_id
  end
end
