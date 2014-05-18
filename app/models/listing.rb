class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :photos

  scope :active, -> { where(active: true) }
end
