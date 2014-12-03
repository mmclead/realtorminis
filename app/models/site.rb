class Site < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user, through: :listing

  validates_presence_of :listing

  #delegate all listing attributes up to the listing
  
  

  
end
