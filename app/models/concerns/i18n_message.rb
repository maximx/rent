module I18nMessage

  private

    def i18n_message(message, options = {})
      translation = "activerecord.errors.models.#{self.class.name.underscore}.attributes.#{message}"
      I18n.t(translation, options)
    end
end
