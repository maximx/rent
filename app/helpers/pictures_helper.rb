module PicturesHelper
  def edit_picture_link(picture)
    if edit_action? and picture.editable_by?(current_user)
      link_to t('controller.action.destroy'),
              picture_path(picture, format: :json),
              method: :delete, remote: true, data: { confirm: t('helpers.common.destroy_confirm') },
              class: 'close remove-picture btn btn-danger'
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

  def render_picture_cover(picture, options = {})
    size_options = { width: 250, height: 180 }
    options = size_options.merge(options)
    image_tag picture.file_url(:cover), options
  end

  def render_picture_cover_list(picture, options = {})
    size_options = { width: 180, height: 130 }
    options = size_options.merge(options)
    image_tag picture.file_url(:cover), options
  end

  def avatar_url_of(user, version = '')
    if user.profile.avatar
      version.blank? ? user.profile.avatar.file.url : user.profile.avatar.file_url(version)
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
      { class: "img-circle img-thumbnail" }
    end
end
