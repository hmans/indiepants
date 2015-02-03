class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter do
    raise "no user configured for this host" unless current_site.present?
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
      helper_method :current_user
    end

    def current_user
      @current_user = current_site   # XXX
    end
  end
end
