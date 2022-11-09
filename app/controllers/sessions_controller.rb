# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session
      remember_me_checked? ? remember(user) : forget(user)
      log_in user
      redirect_to user
    else
      # Use flash.now since render is not a request
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def remember_me_checked?
    params[:session][:remember_me] == '1'
  end
end
