class FileWithImageInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << :hidden

    template.content_tag :div, class: 'carousel picture' do
      template.content_tag :div, class: 'item', style: "background-image: url(#{file_url})" do
        template.content_tag :figure do
          template.concat @builder.file_field(attribute_name, merged_input_options)
          template.concat "<figcaption class='carousel-caption edit_image'>#{I18n.t('helpers.submit.edit')}</figcaption>".html_safe
        end
      end
    end
  end

  def file_url
    if profile? and object.send(attribute_name).present?
      object.send(attribute_name).image.url
    else
      filename = profile? ? 'default-avatar.gif' : 'sample.jpg'
      region = 's3-ap-southeast-1'
      host = 'amazonaws.com'
      bucket = 'guangho-file'
      "https://#{region}.#{host}/#{bucket}/#{filename}"
    end
  end

  def profile?
    object.is_a? Profile
  end
end
