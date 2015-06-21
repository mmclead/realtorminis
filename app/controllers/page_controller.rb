class PageController < ApplicationController
  skip_before_filter :must_be_logged_in
  layout "external"
  def home
  end
end
