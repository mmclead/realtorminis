class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_many :listings, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_one :profile

  def profile_hash 
    profile.profile_hash
  end

  def profile_attribute_list
    profile.profile_attribute_list
  end

end


