class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_many :listings, dependent: :destroy, inverse_of: :user
  has_many :sites, dependent: :destroy, through: :listings
  has_one :profile, dependent: :destroy, inverse_of: :user, autosave: true
  has_many :sub_profiles, class_name: "Profile", dependent: :destroy, inverse_of: :user
  has_one :account, dependent: :destroy, inverse_of: :user, autosave: true

  accepts_nested_attributes_for :profile

  def profile_hash 
    profile.profile_hash
  end

  def profile_attribute_list
    profile.profile_attribute_list
  end

end


