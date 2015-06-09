class AddOriginalUserColumn < ActiveRecord::Migration
  def change
    add_column(:comments, :original_id, :integer)
  end
end
