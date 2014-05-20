class Profile < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true

  mount_uploader :profile_pic, ProfileUploader
  mount_uploader :logo, LogoUploader

  def profile_hash 
    profile_attribute_list.inject({}) {|hash, attribute| hash[attribute] = self.send(attribute); hash}
  end


  def profile_attribute_list
    ["name", "web_site", "tag_line", "contact_email", "phone_number", "dre_number"]
  end
end
