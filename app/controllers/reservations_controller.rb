class ReservationsController < ApplicationController
  
  before_filter :login_required, :only => [ :create, :destroy, :edit, :update, :new ]
  before_filter :must_be_owner, :only => [ :destroy, :edit, :update ] 


  # GET /reservations
  # GET /reservations.xml
  def index
    reservations_list = Reservation.find(:all, 
                          :conditions => ['? <= begining_at AND begining_at <= ?', 
                          Date.today, Date.today + 14.days],
                          :order => "begining_at ASC")

    @reservations = ReservationsController.prepare_reservations_for_view(reservations_list)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.xml
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @reservation }
      format.js {
        render :update do |page|

          page.replace_html \
            "new_reservation_box", 
            :partial => 'details', 
            :locals => { 
              :reservation => @reservation
            }

          page.visual_effect \
            :highlight, 
            "new_reservation_box", 
            :duration => 1
      
        end
      }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.xml
  def new
    @reservation = Reservation.new
    
    # instance of selected day
    date = Date.today + params[:day].to_i.days

    # hours and minutes offset counted from last reservations in this day
    reservation_offset = Reservation.find(:first, 
                              :select => "room_id, MAX(end_at) AS end_at",
                              :conditions => ["(date_trunc('day', begining_at) = " +
                                "date_trunc('day', CAST(? AS timestamp))) AND" +
                                "(begining_at > ? OR end_at > ?)", 
                                date.to_s(:db), Time.zone.now, Time.zone.now],
                              :order => "MAX(end_at) ASC",
                              :group => "room_id")

    begin
      @reservation.date = reservation_offset.end_at.strftime("%H:%M, 15min, %d-%m-%Y")
      @reservation.room_id = reservation_offset.room_id
    rescue
      # TODO move 8.hours internal to settings
      @reservation.date ||= (Date.today + 
                             params[:day].to_i.days +  
                             8.hours).strftime("%H:%M, 15min, %d-%m-%Y")
    end

    respond_to do |format|
      format.xml { render :xml => @reservation }
      format.js {
        render :update do |page|

          page.replace_html \
            "new_reservation_box", 
            :partial => 'form', 
            :locals => { 
              :reservation => @reservation 
            }

          page.visual_effect \
            :highlight, 
            "new_reservation_box", 
            :duration => 1
 
        end
      }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.xml { render :xml => @reservation }
    end
  end

  # POST /reservations
  # POST /reservations.xml
  def create
    @reservation = Reservation.new(params[:reservation])
    @reservation.user_id = current_user.id

    respond_to do |format|
      if @reservation.save
        flash[:notice] = 'Reservation was successfully created.'
        format.xml  { render :xml => @reservation, :status => :created, :location => @reservation }
        format.js { 
          render :update do |page|

            element_id = ReservationsController.create_element_id(@reservation.begining_at)

            page.replace_html \
              "new_reservation_box", 
              :partial => 'form', 
              :locals => { 
                :reservation => Reservation.new 
              }
            

            reservations = ReservationsController.prepare_reservations_for_view(
              Reservation.find(
                  :all, 
                  :conditions => ["date_trunc('day', end_at) = ?", @reservation.end_at.strftime("%Y-%m-%d")],
                  :order => "begining_at ASC"
              )
            )

            page.replace_html \
              element_id,
              :partial => 'day', 
              :locals => { 
                :current_date => @reservation.begining_at.to_date,
                :reservations => reservations[@reservation.end_at.strftime("%Y-%m-%d")]
            }
            
            page.visual_effect \
              :highlight, 
              element_id, 
              :duration => 1
 
          end
        }
      else
        format.xml  { render :xml => @reservation.errors, :status => :unprocessable_entity }
        format.js { 
          render :update do |page|
            
            page.replace_html \
              "new_reservation_box", 
              :partial => 'form', 
              :locals => { 
                :reservation => @reservation
              }
  
            page.visual_effect \
              :highlight, 
              "new_reservation_box", 
              :duration => 1
 
          end
        }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.xml
  def update
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        flash[:notice] = 'Reservation was successfully updated.'
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @reservation.errors, :status => 500 }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.xml
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy

    respond_to do |format|
      format.xml  { head :ok }
      format.js {
        render :update do |page|
          element_id = ReservationsController.create_element_id(@reservation.begining_at)

          reservations = ReservationsController.prepare_reservations_for_view(
              Reservation.find(
                :all, 
                :conditions => ["date_trunc('day', end_at) = date_trunc('day', CAST(? AS timestamp))", 
                  @reservation.begining_at],
                :order => "begining_at ASC"
              )
          )

          page.replace_html \
            element_id,
            :partial => 'day', 
            :locals => { 
              :current_date =>  @reservation.begining_at.to_date,
              :reservations => reservations[@reservation.end_at.strftime("%Y-%m-%d")]
            }

          page.visual_effect \
            :highlight, 
            element_id, 
            :duration => 1
 
        end
      }
    end
  end

  protected

  # FIXME make this more complex and optimal
  def self.prepare_reservations_for_view(reservations_list)
    reservations = Hash.new

    for reserv in reservations_list
      reservations[ reserv.begining_at.to_s(:db).slice(0..9) ] ||= Hash.new

      begin
        reservations[ reserv.begining_at.to_s(:db).slice(0..9) ][ reserv.room_id ] << reserv
      rescue
        reservations[ reserv.begining_at.to_s(:db).slice(0..9) ][ reserv.room_id ] = [ reserv ]
      end
    end

    reservations
  end

  def self.create_element_id(time)
    "#{Date::DAYNAMES[time.wday].downcase}_#{time.day}"
  end
end
