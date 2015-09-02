module I18nMessage
  def i18n_activerecord_error(message, options = {})
    translation = "activerecord.errors.models.#{name.underscore}.attributes.#{message}"
    I18n.t(translation, options)
  end

  def i18n_activerecord_attribute(attr)
    translation = "activerecord.attributes.#{name.underscore}.#{attr}"
    I18n.t(translation)
  end

  def i18n_simple_form_label(attr)
    translation = "simple_form.labels.#{name.underscore}.#{attr}"
    I18n.t(translation)
  end
end
