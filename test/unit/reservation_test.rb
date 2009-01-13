require File.dirname(__FILE__) + '/../test_helper'

class ReservationTest < ActiveSupport::TestCase
  fixtures :reservations
 

  def setup
    @reservation = Reservation.new :room_id => reservations(:today).room_id,
                                  :user_id => reservations(:today).user_id,
                                  :comment => reservations(:today).comment,
                                  :begining_at => reservations(:today).begining_at,
                                  :end_at => reservations(:today).end_at
  end

  def test_reservation_in_future
    # hack to understand that fixtures are in db and start at 8:00am
    if (Time.zone.now.strftime("%H").to_i > 8)
      @reservation.date = (Time.zone.now + 1.hours).strftime("%H:%M, 15min, %d-%m-%Y")
    else
      @reservation.date = Time.zone.now.strftime("10:00, 15min, %d-%m-%Y")
    end
    
    assert @reservation.save, 
      @reservation.errors.full_messages.join(" ") + " " + @reservation.date
  end

  def test_reservation_in_past
    @reservation.date = (Time.zone.now - 1.hours).strftime("%H:%M, 15min, %d-%m-%Y")

    assert !@reservation.save, 
      @reservation.errors.full_messages.join(" ")
   end

  def test_reservation_in_collision
    @reservation.date = @reservation.begining_at.strftime("%H:%M, 15min, %d-%m-%Y")

    assert !@reservation.save, 
      @reservation.errors.full_messages.join(" ")    
  end

  def test_reservation_wrong_date_input
    today = Time.zone.now.strftime("%Y-%m-%d")
    now = Time.zone.now.strftime("%H")

    dates_input = [
      "-#{now}, 15h, #{today}", 
      "aa, 14min, #{today}",
      "#{now}, 15, #{today}aaaa",
      "#{now}, 15min, #{today}11",
      "#{now},,#{today}",
      "#{now},,",
      ",,,"
    ]

    dates_input.each { |date|
      reservation = @reservation.clone
      reservation.date = date
      
      assert !reservation.save, "save complete with wrong date input: "

      reservation.destroy
    }
  end

  def teardown
    @reservation.destroy
  end
end
