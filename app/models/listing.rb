require 'open-uri'

class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_one :site

  scope :active, -> { where(active: true) }

  extend FriendlyId
  friendly_id :address, use: :slugged

  attr_accessor :site_code
  before_save :publish, if: active


  def publish
    #build my has_one associated site
    unless site_code.empty?
      build_site(site_code: site_code)
    end
  end


  def scraped_page
    debugger
    open("/listings/#{self.id}").read
  end
end
