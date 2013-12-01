json.array!(@listings) do |listing|
  json.extract! listing, :index, :show, :new, :create, :edit, :update, :destroy
  json.url listing_url(listing, format: :json)
end
