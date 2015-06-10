module ApplicationHelper
  def render_aside
    if ["items", "categories", "subcategories"].include?(params[:controller])
      render partial: "layouts/category"
    elsif params[:controller].start_with? "settings"
      render partial: "layouts/settings"
    end
  end

  def render_alert(msg)
    @msg = msg
    alert_notice_tag("danger") if msg.present?
  end

  def render_notice(msg)
    @msg = msg
    alert_notice_tag("warning") if msg.present?
  end

  def render_cl_image_small(public_id, options = {})
    default_options = {
      width: 200, height: 150, crop: :fill
    }
    options = options.merge(default_options)
    cl_image_tag(public_id, options)
  end

  def render_cl_image_mid(public_id, options = {})
    default_options = {
      width: 350, height: 250, crop: :fill
    }
    options = options.merge(default_options)
    cl_image_tag(public_id, options)
  end

  private

  def alert_notice_tag(type)
    content_tag(:p, notice_content_with_close,
      class: "alert alert-#{type} alert-dismissible",
      role: :alert
    )
  end

  def notice_content_with_close
    content_tag(:button, span_close,
      type: :button, class: :close,
      data: { dismiss: :alert }, aria: { label: :Close }
    ) +
    content_tag(:strong, @msg)
  end

  def span_close
    content_tag(:span, "x", aria: { hidden: true })
  end
end
