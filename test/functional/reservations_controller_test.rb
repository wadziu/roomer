require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :reservations, :rooms

  def setup
    login_as("quentin")
    @room = rooms(:prezes)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reservations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reservation" do
=begin
    reservation = Reservation.new :room_id => @room.id,
                                  :begining_at => reservations(:tommorow).begining_at + 1.hour,
                                  :end_at => reservations(:tommorow).end_at + 1.hour,
                                  :date => (reservations(:tommorow).end_at + 1.hour).strftime("%h:%m, 15min, %d-%m-%Y"),
                                  :comment => "Test comment"
    reservation.save
=end
    assert_difference('Reservation.count') do
      xhr :post, 
          :create,
          { 
            :reservation => { 
              :room_id => @room.id,
              :date => (reservations(:tommorow).end_at + 1.hour).strftime("%H:%M, 15min, %d-%m-%Y"),
              :comment => "Test comment"
            }
          }
    end

    assert_response :success
  end

  test "should show reservation" do
    get :show, :id => reservations(:today).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reservations(:today).id
    assert_response :success
  end

  test "should update reservation" do
    put :update, :id => reservations(:today).id, :reservation => { }
    assert_response :error
  end

  test "should destroy reservation" do
    assert_difference('Reservation.count', -1) do
      xhr :delete,
          :destroy,
          { :id => reservations(:today).id }
    end

    assert_response :success
  end
end
