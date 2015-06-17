module PicturesHelper

  def render_cl_image_small(public_id, options = {})
    default_options = { width: 200, height: 150, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_image_mid(public_id, options = {})
    default_options = { width: 350, height: 250, crop: :fill }
    cl_image_tag(public_id, default_options, options)
  end

  def render_cl_avatar_small(user, options = {})
    public_id = if user.profile && user.profile.picture
                  user.profile.picture.public_id
                else
                  DEFAULT_AVATAR
                end
    default_options = { width: 75, height: 75, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_avatar_medium(user, options = {})
    public_id = if user.profile && user.profile.picture
                  user.profile.picture.public_id
                else
                  DEFAULT_AVATAR
                end
    default_options = { width: 150, height: 150, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_image(public_id, default_options, options = {})
    options = options.merge(default_options)
    cl_image_tag(public_id, options)
  end

end
