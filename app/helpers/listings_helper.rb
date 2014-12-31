module ListingsHelper

  def active_status(listing)
    if listing.active
      render partial: '/listings/index/active_site_options', locals: {listing: listing}
    else
      render partial: '/listings/index/activate_link', locals: {listing: listing}
    end
  end

end
