module PicturesHelper
  def render_cl_image_xs(public_id, options = {})
    default_options = { width: 100, height: 75, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_image_sm(public_id, options = {})
    default_options = { width: 200, height: 150, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_image_md(public_id, options = {})
    default_options = { width: 250, height: 180, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_image_lg(public_id, options = {})
    default_options = { width: 450, height: 350, crop: :fill }
    render_cl_image(public_id, default_options, options)
  end

  def render_cl_avatar_xs(user, options = {})
    size_options = { width: 30, height: 30 }
    size_options.reverse_merge! avatar_default_options
    public_id = public_id_of(user)

    render_cl_image(public_id, size_options, options)
  end

  def render_cl_avatar_sm(user, options = {})
    size_options = { width: 50, height: 50 }
    size_options.reverse_merge! avatar_default_options
    public_id = public_id_of(user)

    render_cl_image(public_id, size_options, options)
  end

  def render_cl_avatar_md(user, options = {})
    size_options = { width: 100, height: 100 }
    size_options.reverse_merge! avatar_default_options

    public_id = public_id_of(user)

    render_cl_image(public_id, size_options, options)
  end

  def render_cl_avatar_lg(user, options = {})
    size_options = { width: 200, height: 200, crop: :fill, gravity: :face }
    public_id = public_id_of(user)
    render_cl_image(public_id, size_options, options)
  end

  def render_cl_image(public_id, default_options, options = {})
    options = default_options.merge(options)
    cl_image_tag(public_id, options)
  end

  def public_id_of(user)
    if user.profile && user.profile.picture
      user.profile.picture.public_id
    else
      DEFAULT_AVATAR
    end
  end

  private

    def avatar_default_options
      { crop: :fill, gravity: :face, radius: :max, class: "img-circle img-thumbnail" }
    end
end
