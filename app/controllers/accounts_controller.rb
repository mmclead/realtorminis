class AccountsController < ApplicationController
  respond_to :html, :js
  load_and_authorize_resource :user

  def show
    @account = @user.account
    @listings = @user.listings
    @sites = @user.sites
  end


  def payment_details
    render partial: 'payment_details_body', locals: {reciept_credit: @user.listings.where(id: params[:for_listing]).first.try(:reciept_credit)}
  end
end

