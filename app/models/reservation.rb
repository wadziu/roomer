class Reservation < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
  
  attr_accessor :date

  validates_presence_of :room_id
  validates_numericality_of :room_id

  before_validation :resolve_datetime_range


  protected

  def validate
    # verify begining_at date and end_at date they aren't from past
    errors.add('Date in past',' select date ranges from future or present, not from past') \
      if self.begining_at.past? or self.end_at.past?

    # verify end_at range
    errors.add('End date out of time', ' select end date in same day as begining date') \
      if self.begining_at.wday != self.end_at.wday

    # check end_at it's not earlier than begining_at
    errors.add('End date out of time', ' select end date after begining date') \
      if self.begining_at >= self.end_at

    # check that begining_at date is in near the nearest future (13 days)
    errors.add('Out of time', ' select begining date in next 13 days') \
      if begining_at > (Date.today + 13.days)

    # check begining_at and end_at it's not between other 
    # reservations or doesn't contain any
    # FIXME optimalize validation query
    errors.add('Datetime collision', ' select another available datetime') \
      if Reservation.find(:all, 
        :conditions => [ 
          "(
            (
              -- date impose to other one
              (begining_at > :b AND begining_at < :e) OR 
              (end_at > :b AND end_at < :e) OR 
              (:b > begining_at AND :b < end_at) OR 
              (:e > begining_at AND :e < end_at)
            )
          OR
            (
              -- date is same as other one
              date_trunc('minute', begining_at) = date_trunc('minute', CAST(:b AS timestamp)) AND
              date_trunc('minute', end_at) = date_trunc('minute', CAST(:e AS timestamp))
            )
          )

          AND
          (
            -- only reservations in same day
            date_trunc('day', begining_at) = date_trunc('day', CAST(:b AS timestamp)) AND
            date_trunc('day', end_at) = date_trunc('day', CAST(:e AS timestamp)
          ) 

          AND
          (          
            -- only reservations for same room
            room_id = :rid
          ))",
          { 
            :b => self.begining_at, 
            :e => self.end_at, 
            :rid => self.room_id
           }
        ] 
      ).length > 0
  end

  # Set begining_at and end_at datetime of reservation
  # usign data from :date field 
  #
  # format: H:M, M|H, dd-mm-YYYY
  # example: 13:00, 2h, 12-12-2000
  #
  def resolve_datetime_range
    # TODO make this method clear
    date_context = self.date.split(",") # [ start_time, occupation_time, date(dd-mm-yyyy) ]

    # initialize reservation's begining datetime
    begining_at = Proc.new {
      hours, minutes = date_context[0].split(":")

      # round up timer for next number divided by 5
      while minutes.to_i%5 != 0 do
        minutes = minutes.to_i + 1
      end

      Time.zone.parse(date_context[2]) + hours.to_i.hours + minutes.to_i.minutes
    }

    # initialize reservation's end datetime
    end_at = Proc.new {
      minutes = date_context[1].to_i

      # round up timer for next number divided by 5
      while minutes%5 != 0 do
        minutes = minutes + 1
      end

      minutes = minutes.*60 if not /h/.match(date_context[1]).nil?
  
      begining_at.call + minutes.to_i.minutes
    }

    # set begining and end datetime value
    self.begining_at, self.end_at = begining_at.call, end_at.call
  end
end
