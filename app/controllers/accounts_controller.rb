class AccountsController < ApplicationController
  respond_to :html
  load_and_authorize_resource :user

  def show

    @account = @user.account
    @sites = @user.sites
  end
end

