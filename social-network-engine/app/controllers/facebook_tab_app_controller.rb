class FacebookTabAppController < ApplicationController
  def signup
  end

  def load_account
    @user = current_user

    if @user.nil?
      redirect_to "/facebook_tab_app/signup"
    end
  end

  def create_account
    @user = current_user
    no_errors = @user.update_attributes(params[:user])

    if no_errors
      # Get friends from Facebook
      # NOTE: friend object returned from Facebook has the form:
      #   { "name" : "<friend name>", "id" : "<friend Facebook id>"}
      @graph = Koala::Facebook::API.new(@user.token)
      @user.ImportFriends(@graph.get_connections("me", "friends").map{
          |i| i["id"]})

      redirect_to "/facebook_tab_app/done"
    else
      render 'load_account'
    end
  end

  def done
  end
end
