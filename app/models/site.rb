class Site < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user

  validates_presence_of :listing
  validates_presence_of :site_code


  before_save :upload_to_aws


  def upload_to_aws
     #push the site_code blob up to aws
  end

end
