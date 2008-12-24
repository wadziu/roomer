class Room < ActiveRecord::Base
  has_many :reservations

  validates_presence_of :name

  #validates_numericality_of :number
  #validates_uniqueness_of :number
end
