require File.dirname(__FILE__) + '/../test_helper'

class RoomTest < ActiveSupport::TestCase
  fixtures :rooms

  def test_room
    prezes_room = Room.new  :name => rooms(:prezes).name,
                            :number => rooms(:prezes).number,
                            :description => rooms(:prezes).description

    assert prezes_room.save

    prezes_room_copy = Room.find(prezes_room.id)

    assert_equal prezes_room.name, prezes_room_copy.name

    assert prezes_room.save
    assert prezes_room.destroy
  end
end
