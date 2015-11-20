class FileWithImageInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << :hidden

    template.content_tag :div, class: 'carousel avatar' do
      template.content_tag :div, class: 'item', style: "background-image: url(#{image_url})" do
        template.content_tag :figure do
          template.concat @builder.file_field(attribute_name, merged_input_options)
          template.concat "<figcaption class='carousel-caption edit_image'>編輯</figcaption>".html_safe
        end
      end
    end
  end

  def image_url
    ApplicationController.helpers.cloudinary_url(avatar_public_id, crop: :fill, gravity: :face)
  end

  def avatar_public_id
    picture? ?  object.send(attribute_name) : Rent::DEFAULT_AVATAR
  end

  def picture?
    object.send(attribute_name).present?
  end
end
