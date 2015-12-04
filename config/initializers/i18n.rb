I18n.backend.instance_eval do
  def interpolate(locale, string, values = {})
    if string.is_a?(::Array) && !values.empty?
      string.map { |el| super(locale, el, values) }.join
    else
      super
    end
  end
end
