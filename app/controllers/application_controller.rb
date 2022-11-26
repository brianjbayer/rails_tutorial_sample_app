# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    # Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        # Store the original requested URl for friendly forwarding
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url, status: :see_other
      end
    end
end
