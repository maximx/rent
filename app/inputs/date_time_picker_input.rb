class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    Rails.logger.info input_html_options
    template.content_tag(:div, class: 'input-group date form_datetime') do
      template.concat @builder.text_field(attribute_name, picker_input_html_options)
      template.concat span_table
    end
  end

  def picker_input_html_options
    input_html_options[:class] << "form-control"
    input_html_options[:placeholder] = "年-月-日"
    input_html_options
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_table
    end
  end

  def icon_table
    "<i class='glyphicon glyphicon-th'></i>".html_safe
  end
end
