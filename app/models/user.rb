class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_many :listings, dependent: :destroy
  has_many :sites, dependent: :destroy

  mount_uploader :profile_pic, ProfileUploader
  mount_uploader :logo, LogoUploader

  def profile_hash 
    profile_attribute_list.inject({}) {|hash, attribute| hash[attribute] = self.send(attribute); hash}
  end


  def profile_attribute_list
    ["name", "web_site", "contact_email", "phone_number", "dre_number", "tag_line"]
  end
end


