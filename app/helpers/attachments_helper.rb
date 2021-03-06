module AttachmentsHelper
  def destroy_attachment_link(attachment)
    if attachment.editable_by?(current_user) and ['edit', 'update', 'destroy'].include?(action_name)
      link_to raw('&times;'),
              attachment_path(attachment),
              class: 'close remove-picture btn',
              data: {confirm: t('helpers.common.destroy_confirm')},
              method: :delete,
              remote: true
    end
  end

  def render_avatar(user, options = {})
    size_options = { width: 30, height: 30 }
    size_options.reverse_merge! avatar_default_options
    options = size_options.merge(options)
    image_tag avatar_url_of(user, :thumb), options
  end

  def render_avatar_thumb(user, options = {})
    size_options = { width: 50, height: 50 }
    size_options.reverse_merge! avatar_default_options
    options = size_options.merge(options)
    image_tag avatar_url_of(user, :thumb), options
  end

  def render_avatar_thumb_md(user, options = {})
    size_options = {width: 100, height: 100}
    size_options.reverse_merge! avatar_default_options
    options = size_options.merge(options)
    image_tag avatar_url_of(user, :thumb), options
  end

  def render_avatar_logo(user, options = {})
    size_options = { width: 50, height: 50 }
    options = size_options.merge(options)
    image_tag avatar_url_of(user, :thumb), options
  end

  def render_picture_cover(picture, options = {})
    size_options = { width: 250, height: 180 }
    options = size_options.merge(options)
    image_tag picture.image_url(:cover), options
  end

  def render_picture_cover_for_list(picture, options = {})
    size_options = { width: 180, height: 130 }
    options = size_options.merge(options)
    image_tag picture.image_url(:cover), options
  end

  def avatar_url_of(user, version = '')
    if user.profile.avatar
      version.blank? ? user.profile.avatar.image.url : user.profile.avatar.image_url(version)
    else
      filename = t('rent.default_avatar')
      region = 's3-ap-southeast-1'
      host = 'amazonaws.com'
      bucket = 'guangho-file'
      "https://#{region}.#{host}/#{bucket}/#{filename}"
    end
  end

  private
    def avatar_default_options
      { class: 'img-thumbnail' }
    end
end
