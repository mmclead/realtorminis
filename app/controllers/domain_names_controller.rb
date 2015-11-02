class DomainNamesController < ApplicationController
  load_and_authorize_resource :user
  before_filter :set_listing, only: [:create]
  respond_to :js, :json

  include PurchaseableControllerHelper

  def create
    @domain_name = @listing.domain_names.build(domain_name_params)
    if @domain_name.save
      @domain_name.email_operations
      charge_customer_with_stripe(Rails.configuration.prices[:custom_domain], @domain_name.purchase_description, params, @domain_name)
      @domain_name.purchased!
      @listing.site.publish_custom_domains
      
      DomainRegistrationJob.new.async.perform(@domain_name.id)
      redirect_to listings_path, notice: 'Custom Domain Name added.'
    else
      redirect_to listings_path, alert: 'Custom Domain Name could not be added.  You were not charged'
    end
  end

  def check_availability
    domain_name = CustomDomainName.new(name: params[:name])
    render json: {available: false} and return unless domain_name.valid?
    begin
      available = domain_name.domain_is_available? 
    rescue StandardError => e
      available = false
      logger.warn "Could not check_availability for domain #{domain_name.name}, #{e.message}"
    end
    render json: {available: available}
  end

  def check_status 
    domain_name = CustomDomainName.find(params[:id])
    render partial: "#{domain_name.status}_partial" and return
  end


 private

  def set_listing
    @listing = @user.listings.where(id: domain_name_params[:listing_id]).first
  end

  def domain_name_params 
    params.require(:domain_name).permit(:listing_id, :name)
  end

end

