class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Selects locale according to user's selection & athenticates users
  before_action :set_locale

  protected

    def set_locale
      if cookies[:mymms_locale] && I18n.available_locales.include?(cookies[:mymms_locale].to_sym)
        l = cookies[:mymms_locale].to_sym
      else
        begin
          country_code = request.location.country_code
          if country_code
            country_code = country_code.downcase.to_sym
            # Use simplified Chinese for China mainland, English for others
            #[:zh_CN, :ru, :kz, :ua, :by, :tj, :uz, :md, :az, :am, :kg, :tm].include?(country_code) ? l = :Zh_CN : l = :en
            [:zh_CN].include?(country_code) ? l = :Zh_CN : l = :en
          else
            l = I18n.default_locale # use default locale if cannot retrieve this info
          end
        rescue
          l = I18n.default_locale
        ensure
          cookies.permanent[:mymms_locale] = l
        end
      end
      I18n.locale = l
    end
end
