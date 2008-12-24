require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
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
    assert_difference('Reservation.count') do
      post :create, :reservation => { }
    end

    assert_redirected_to reservation_path(assigns(:reservation))
  end

  test "should show reservation" do
    get :show, :id => reservations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reservations(:one).id
    assert_response :success
  end

  test "should update reservation" do
    put :update, :id => reservations(:one).id, :reservation => { }
    assert_redirected_to reservation_path(assigns(:reservation))
  end

  test "should destroy reservation" do
    assert_difference('Reservation.count', -1) do
      delete :destroy, :id => reservations(:one).id
    end

    assert_redirected_to reservations_path
  end
end
