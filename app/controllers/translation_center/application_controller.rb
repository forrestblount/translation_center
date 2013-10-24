module TranslationCenter
  class ApplicationController < ActionController::Base
    before_filter :authenticate_admin!
    before_filter :set_user
    before_filter :translation_langs_filters

    if Rails.env.development?

      # if an exception happens show the error page
      rescue_from Exception do |exception|
        @exception = exception
        @path = request.path

        render "translation_center/errors/exception"
      end
      
    end

    def set_user
      # tc needs a current_user, but we want to use current_admin
      if current_admin
        current_user = current_admin
      end
    end

    # defaults
    def translation_langs_filters
      session[:current_filter] ||= 'untranslated'
      session[:lang_from] ||= :en
      session[:lang_to] = params[:lang_to] || session[:lang_to] || :en
      I18n.locale = session[:lang_from] || I18n.default_locale
    end

    protected
    
    def can_admin?
      current_user.can_admin_translations?
    end

    def set_page_number
      params[:page] ||= 1
      @page = params[:page].to_i
    end

  end
end
