class NumericAddonInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group addon') do
      template.concat @builder.number_field(attribute_name, picker_input_html_options)
      template.concat span_table
    end
  end

  def picker_input_html_options
    input_html_options[:class] << 'form-control'
    input_html_options
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat options[:direction]
    end
  end
end
