class HomeController < ApplicationController
  def index
    @reservations = Reservation.find(:all, :conditions => ['begining_at < ?', Time.now])
  end
end
