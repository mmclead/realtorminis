class CreditsController < ApplicationController
  load_and_authorize_resource :user
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

    Credit.create(account_id: @user.account.id, purchaseable: @listing, purchased_at: Time.now, spent_at: Time.now, payment_details: charge.to_h)
    
    patch user_listing_path(@user, listing, {listing:{active: true}})
    # redirect_to user_listings_path(@user)

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    debugger
    redirect_to user_listings_path(@user)
  end

end