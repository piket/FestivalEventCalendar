class AddDurationColumn < ActiveRecord::Migration
  def change
    add_column(:events, :duration, :integer)
  end
end
