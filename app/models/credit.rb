class Credit < ActiveRecord::Base
  belongs_to :account
  belongs_to :purchaseable, polymorphic: true
end
