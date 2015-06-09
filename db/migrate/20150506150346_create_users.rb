class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :type
      t.string :gender
      t.string :location
      t.string :age
      t.boolean :status
      t.string :provider
      t.string :provider_id

      t.timestamps null: false
    end
  end
end
