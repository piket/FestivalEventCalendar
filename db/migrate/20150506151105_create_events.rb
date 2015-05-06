class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.datetime :date
      t.text :description
      t.string :image
      t.string :video
      t.string :link
      t.string :purchase
      t.float :price
      t.references :organizer, index: true

      t.timestamps null: false
    end
  end
end
