class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :subject
      t.text :body
      t.boolean :unread
      t.references :user, index: true, foreign_key: true
      t.references :commentable, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end
