class AccountsController < ApplicationController
  respond_to :html, :js
  load_and_authorize_resource :user

  def show
    @account = @user.account
    @listings = @user.listings
    @sites = @user.sites
    @domain_names = @user.domain_names.sort_by(&:listing_id)
  end


  def payment_details

    case params[:for_item]
    when "domain_name"
      render partial: 'payment_details_body', locals: {reciept_credit: @user.domain_names.where(id: params[:for_item_id]).first.try(:reciept_credit)}
    when "listing"
      render partial: 'payment_details_body', locals: {reciept_credit: @user.listings.where(id: params[:for_item_id]).first.try(:reciept_credit)}
    else
      return false
    end
  end
end

