class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :ensure_current_site

  def ensure_current_site
    redirect_to :pants_setup unless current_site.present?
  end

  concerning :CurrentSite do
    included do
      helper_method :current_site
    end

    def current_site
      @current_site ||= User.where(host: request.host).take
    end
  end

  concerning :CurrentUser do
    included do
      helper_method :current_user, :logged_in?, :logged_out?
    end

    def logged_in?
      current_user.present? && current_user == current_site
    end

    def logged_out?
      !logged_in?
    end

    def current_user
      @current_user ||= load_current_user
    end

    def load_current_user
      current_user_id = session[:current_user_id]
      if current_user_id
        User.where(id: current_user_id).take || logout_user
      end
    end

    def login_user(user)
      session[:current_user_id] = user.id
    end

    def logout_user
      session[:current_user_id] = nil
    end
  end
end
