class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_one :site

  scope :active, -> { where(active: true) }

  extend FriendlyId
  friendly_id :address, use: :slugged

  before_save publish, if: active


  def publish
    tmp_site = Tempfile.new("#{id}-#{address}")
    html = open("http://web.archive.org/web/20120502173130/http://magmarails.com/")
    tmp_site << html

    #push the file or html to AWS

  end
end
