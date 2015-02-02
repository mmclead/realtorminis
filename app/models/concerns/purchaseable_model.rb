module PurchaseableModel
  extend ActiveSupport::Concern

  included do 
    def is_paid_for?
      Credit.where(purchaseable: self).count > 0
    end

    def reciept_credit
      Credit.where(purchaseable: self).first
    end
  end
end

