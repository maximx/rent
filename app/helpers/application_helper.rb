module ApplicationHelper
  def render_aside
    if ["items", "categories", "subcategories", "rent_records"].include?(params[:controller])
      render partial: "layouts/category"
    elsif ["profiles"].include?(params[:controller]) || params[:controller].start_with?("settings")
      render partial: "layouts/settings"
    end
  end

  def render_css_class(obj_id, target_id, css)
    " #{css.to_s}" if obj_id.to_i == target_id.to_i
  end

  def render_alert(msg)
    @msg = msg
    alert_notice_tag("danger") if msg.present?
  end

  def render_notice(msg)
    @msg = msg
    alert_notice_tag("warning") if msg.present?
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
