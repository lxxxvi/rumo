class TestExceptionLocalizationHandler
  def call(exception, locale, key, options)
    raise exception.to_exception
  end
end

I18n.available_locales = %i[en de]
I18n.default_locale = :en
I18n.exception_handler = TestExceptionLocalizationHandler.new
