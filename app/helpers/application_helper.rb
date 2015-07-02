module ApplicationHelper

  def render_aside
    if ["items", "categories", "subcategories", "rent_records"].include?(params[:controller])
      render partial: "common/category"
    elsif settings_page?
      render partial: "common/settings"
    elsif "users" == params[:controller]
      render partial: "common/user_navigation"
    else
      content_tag(:p, "")
    end
  end

  def settings_page?
    "profiles" == params[:controller] || params[:controller].start_with?("settings")
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

  def render_link_li(list=[], options={})
    if list.is_a? Hash
      options = list
      list = []
    end
    yield(list) if block_given?

    li_link = []

    list.each_with_index do |li, index|
      active_class = if current_page? li[1]
                       " active"
                     else
                       ""
                     end
      css_class = "list-group-item#{active_class}"
      li_link << content_tag(:li, link_to(li[0], li[1]), class: css_class)
    end

    content_tag(:ul, li_link.join.to_s.html_safe, options)
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
