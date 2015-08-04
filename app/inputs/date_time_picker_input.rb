class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    Rails.logger.info input_html_options
    template.content_tag(:div, class: 'form-group') do
      template.concat @builder.text_field(attribute_name, picker_input_html_options)
    end
  end

  def picker_input_html_options
    input_html_options[:class] << 'form-control date form_datetime'
    input_html_options[:placeholder] = '年-月-日'
    input_html_options
  end
end
