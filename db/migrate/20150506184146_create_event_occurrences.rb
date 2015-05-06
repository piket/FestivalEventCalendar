class CreateEventOccurrences < ActiveRecord::Migration
  def change
    create_table :event_occurrences do |t|
      t.datetime :date
      t.string :location
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
