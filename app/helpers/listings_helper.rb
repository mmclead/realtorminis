module ListingsHelper

  def active_status(listing)
    if listing.active
      content_tag(:button, class: "btn btn-primary disabled") do
        "You are live!" 
      end
    else
      render partial: '/listings/index/activate_link', locals: {listing: listing}
    end
  end

end
