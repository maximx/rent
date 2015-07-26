module ApplicationHelper
  def render_meta_tags
    display_meta_tags(
      site: SITE_NAME,
      keywords: KEYWORDS,
      og: { site_name: SITE_NAME, type: "website" },
      reverse: true
    )
  end

  def render_category_navbar
    if ["items", "categories", "subcategories", "rent_records"].include?(params[:controller])
      render partial: "common/category_navbar"
    end
  end

  def render_aside_navigation
    if settings_page?
      render partial: "common/settings_navigation"
    elsif "users" == params[:controller]
      render partial: "common/users_navigation"
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

  def render_link_li(list=[], options={})
    if list.is_a? Hash
      options = list
      list = []
    end
    yield(list) if block_given?

    li_link = []

    list.each_with_index do |li, index|
      link_options = if li[2] && li[2][:link_html]
                       li[2][:link_html]
                     else
                       {}
                     end
      li_options = if li[2] && li[2][:li_html]
                     li[2][:li_html]
                   else
                     {}
                   end

      li_css_class = []
      li_css_class << li_options[:class] if li_options[:class]

      active_class = (current_page? li[1].gsub(/#.*/, '') ) ? "active" : ""
      li_css_class << active_class

      li_options[:class] = li_css_class.join(" ")
      li_link << content_tag(:li, link_to(li[0], li[1], link_options), li_options)
    end

    content_tag(:ul, li_link.join.to_s.html_safe, options)
  end

  def render_icon_with_text(icon, text, options = {})
    css_class = []
    css_class << options[:class] if options[:class]
    css_class << "text"
    options[:class] = css_class.join(" ")

    "#{render_icon(icon, options)}#{text}".html_safe
  end

  def render_icon(icon, options = {})
    css_class = []
    css_class << options[:class] if options[:class]
    css_class << "glyphicon glyphicon-#{icon}"
    options[:class] = css_class.join(" ")

    content_tag(:span, nil, options)
  end

  def render_default_content(obj, text = nil, &block)
    text = capture(&block) if block_given?

    if obj.nil?
      render_mute text
    elsif obj.empty?
      render_mute text
    end
  end

  def render_mute(text)
    content_tag(:h3, text, class: "text-muted text-center")
  end

  def active_link_to(body, url, html_options = {})
    css_class = []
    css_class << "active" if current_page? url
    css_class << html_options[:class] if html_options.has_key?(:class)
    html_options[:class] = css_class.join(" ")

    link_to body, url, html_options
  end

  def settings_page?
    "profiles" == params[:controller] || params[:controller].start_with?("settings")
  end

  def is_remote?(type)
    type.to_sym == :remote
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
