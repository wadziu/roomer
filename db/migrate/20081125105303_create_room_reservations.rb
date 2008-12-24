class CreateRoomReservations < ActiveRecord::Migration
  def self.up
    create_table :room_reservations do |t|
      t.string :supplicant
      t.text :comment
      t.datetime :begining_at
      t.datetime :end_at
      t.references :room
      t.timestamps
    end
  end

  def self.down
    drop_table :room_reservations
  end
end
