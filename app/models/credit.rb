class Credit < ActiveRecord::Base
  belongs_to :account
  belongs_to :purchaseable, polymorphic: true


  def payment_card
    "#{(YAML.load payment_details['card'])['brand']} #{(YAML.load payment_details['card'])['last4']}"
  end

  def payment_amount
    payment_details['amount'].to_f / 100.0
  end

  def transaction_id
    "#{payment_details['id']}"
  end
end
