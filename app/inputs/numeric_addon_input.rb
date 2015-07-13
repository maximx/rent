class NumericAddonInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group addon') do
      template.concat @builder.number_field(attribute_name, input_html_options)
      template.concat span_table
    end
  end

  def input_html_options
    { class: 'form-control' }
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat options[:direction]
    end
  end

end
