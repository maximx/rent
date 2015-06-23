class UserPasswordLoginInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_wrapper_options = merge_wrapper_options(input_html_options, wrapper_options)
    template.content_tag(:div, class: "col-sm-10") do
      @builder.password_field(attribute_name, input_wrapper_options)
    end
  end
end

