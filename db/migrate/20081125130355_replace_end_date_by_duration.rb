class ReplaceEndDateByDuration < ActiveRecord::Migration
  def self.up
    remove_column :room_reservations, :end_at
    remove_column :room_reservations, :duration
    add_column :room_reservations, :duration, :integer
  end

  def self.down
    change_table(:room_reservations) do |t|
      t.datetime :end_at
    end
    remove_column :room_reservations, :duration
  end
end
