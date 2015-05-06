class CreateEventOccurrencesUsers < ActiveRecord::Migration
  def change
    create_table :event_occurrences_users do |t|
      t.references :event_occurrence, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
