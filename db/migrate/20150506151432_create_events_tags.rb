class CreateEventsTags < ActiveRecord::Migration
  def change
    create_table :events_tags do |t|
      t.references :event, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
