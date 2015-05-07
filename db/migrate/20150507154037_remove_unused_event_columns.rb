class RemoveUnusedEventColumns < ActiveRecord::Migration
  def change
    remove_column(:events, :date)
    remove_column(:events, :location)
  end
end
