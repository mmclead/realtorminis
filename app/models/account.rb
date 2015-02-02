class Account < ActiveRecord::Base
  belongs_to :user, inverse_of: :account

  has_many :credits, inverse_of: :account


  

end
