require 'open-uri'

class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_one :site
  has_many :domain_names

  scope :active, -> { where(active: true) }
  scope :deleted, -> { where(deleted: true) }
  scope :not_deleted, -> { where(deleted: [false, nil]) }
  
  include PurchaseableModel

  attr_accessor :site_code

  before_save (:delete_site), if: :deleting_active_listing? 

  validates_presence_of :address, :city, :state, :title, :price, :bedrooms, :bathrooms, :sq_ft, :short_description, :description
  validates_uniqueness_of :web_address, allow_nil: true

  auto_html_for :video_link do
    html_escape
    youtube(width: 640, height:360)
    vimeo(width: 640, height:360)
  end

  def has_new_changes?
    latest_update = [updated_at, photos.last.updated_at].max rescue updated_at
    latest_update > published_at rescue true
  end

  def publish!
    #build my has_one associated site
    unless site_code.empty?
      if self.site
        self.site.update(site_code: site_code)
      else
        build_site(site_code: site_code, listing_id: self.id).save
      end
      self.published_at = Time.now + 5.seconds
      self.active = true
      self.save!
    end
  end

  def full_address
    "#{address} #{city}, #{state} #{zip}"
  end

  def full_web_address
    "#{site.bucket}/#{site.custom_url}" unless site.nil?
  end

  def key_photo
    photos.order(order: :asc).first.key rescue ''
  end

  def map_from_address
    %Q[
      <iframe width="600"
        height="450"
        frameborder="0" style="border:0"
        src="https://www.google.com/maps/embed/v1/place?key=AIzaSyD6yANsGxi84DBW8ZlGcS1Ka-fh8MCS-Q8&q=#{full_address}">
      </iframe>
    ]
  end

  def purchase_description
    "Real estate listing site"
  end

  def deleting_active_listing?
    active_changed?(from: true, to: false)
  end

  def destroy
    self.update(active: false, deleted: true)
  end

  def delete_site
    self.site.destroy if self.site
  end

end
