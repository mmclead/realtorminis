class CreditsController < ApplicationController
  respond_to :html

  def new
  end

  def create
    @amount = 1000

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: "listing site",
      currency: 'usd'
    )

    @listing = Listing.find(params[:listing_id])
    Credit.create(account_id: current_user.account.id, purchaseable: @listing, purchased_at: Time.now, spent_at: Time.now, payment_details: charge.to_h)
    patch listing_path(listing, {listing:{active: true}})

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to listings_path
  end

end