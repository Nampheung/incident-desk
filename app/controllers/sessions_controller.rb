class SessionsController < ApplicationController
  layout "signed_out"

  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render_rate_limited }
  before_action :redirect_if_signed_in, only: %i[ new create ]

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private
    def redirect_if_signed_in
      redirect_to root_path if authenticated?
    end

    def render_rate_limited
      flash.now[:alert] = "Too many sign-in attempts. Try again in a few minutes."
      render :new, status: :too_many_requests
    end
end
