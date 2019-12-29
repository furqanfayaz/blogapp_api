class CreateBlogTables < ActiveRecord::Migration[5.0]

  def up
    create_table :posts, id: :uuid do |t|
      t.references :user, type: :uuid, index: true
      t.string :title
      t.string :content
      t.string :media

      t.timestamps
    end

    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    create_table :comments, id: :uuid do |t|
      t.references :post, type: :uuid, index: true
      t.references :user, type: :uuid, index: true
      t.string :title
      t.string :content

      t.timestamps
    end

    add_foreign_key :comments, :posts, column: :post_id
    add_foreign_key :comments, :users, column: :user_id
    add_foreign_key :posts, :users, column: :user_id
  end

    def down
      drop_table :posts
      drop_table :users
      drop_table :comments
    end
end