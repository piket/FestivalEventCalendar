class AddFestivalIdColumn < ActiveRecord::Migration
  def change
        add_column(:comments, :festival_id, :integer)
  end
end
