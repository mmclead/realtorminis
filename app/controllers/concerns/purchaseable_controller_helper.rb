module PurchaseableControllerHelper
  extend ActiveSupport::Concern

  included do 
    def charge_customer_with_stripe(amount, form_params, purchaseable_object)
    
      customer = Stripe::Customer.create(
        email: form_params[:stripeEmail],
        card: form_params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: amount,
        description: "listing site",
        currency: 'usd'
      )

      Credit.create(
        account_id: @user.account.id, 
        purchaseable: purchaseable_object, 
        purchased_at: Time.now, 
        spent_at: Time.now, 
        payment_details: charge.to_h
      )
    end
  end
end

