require 'open-uri'

class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_one :site

  scope :active, -> { where(active: true) }

  extend FriendlyId
  friendly_id :address, use: :slugged

  attr_accessor :site_code

  def publish!
    #build my has_one associated site
    unless site_code.empty?
      if self.site
        self.site.update(site_code: site_code)
      else
        build_site(site_code: site_code, listing_id: self.id).save
      end
    end
  end

end
