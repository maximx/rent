module I18nMessage

  private

    def i18n_activerecord_error(message, options = {})
      translation = "activerecord.errors.models.#{self.class.name.underscore}.attributes.#{message}"
      I18n.t(translation, options)
    end

    def i18n_activerecord_attribute(attr)
      translation = "activerecord.attributes.#{self.class.name.underscore}.#{attr}"
      I18n.t(translation)
    end
end
