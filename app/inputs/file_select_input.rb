class FileSelectInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    out = ActiveSupport::SafeBuffer.new

    out << div_input_group
    out << file_select_input
    out << file_name_input
    out << div_end
  end

  def div_input_group
    "<div class='input-group'>".html_safe
  end

  def div_end
    "</div>".html_safe
  end

  def file_select_input
    template.content_tag(:span, class: 'input-group-btn') do
      template.content_tag(:span, class: 'btn btn-primary btn-file') do
        template.concat "選擇檔案"
        template.concat @builder.file_field(attribute_name, input_html_options)
      end
    end
  end

  def file_name_input
    "<input type='text' class='form-control file-name' readonly>".html_safe
  end
end
