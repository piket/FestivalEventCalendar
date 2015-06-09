class ChangeColumnOrganizer < ActiveRecord::Migration
  def change
    rename_column(:events, :organizer_id, :host_id)
  end
end
