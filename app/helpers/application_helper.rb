module ApplicationHelper
  def render_meta_tags
    display_meta_tags(
      site: Rent::SITE_NAME,
      keywords: Rent::KEYWORDS,
      description: Rent::DESCRIPTION,
      og: {
        site_name: Rent::SITE_NAME,
        type: 'website',
        image: asset_url('logo'),
        url: request.original_url,
        title: "#{Rent::SUB_TITLE} - #{Rent::SITE_NAME}",
        description: Rent::DESCRIPTION
      },
      reverse: true,
      viewport: "width=device-width, initial-scale=1"
    )
  end

  def render_navigation
    if settings_account_related_controller?
      render partial: 'common/navigation', locals: { list: settings_navbar_list }
    elsif dashboard_related_controller?
      render partial: 'common/navigation', locals: { list: dashboard_navbar_list }
    elsif ["notifications", "conversations"].include? params[:controller]
      render partial: 'common/navigation', locals: { list: conversations_navbar_list }
    elsif pages_controller? and !pages_index_action?
      render partial: 'common/navigation', locals: { list: pages_navbar_list }
    end
  end

  def render_alert(msg)
    alert_notice_tag("danger", msg) if msg.present?
  end

  def render_notice(msg)
    alert_notice_tag("warning", msg) if msg.present?
  end

  def render_link_li(list=[], options={})
    if list.is_a? Hash
      options = list
      list = []
    end
    yield(list) if block_given?

    li_link = []

    list.each_with_index do |li, index|
      link_options = (li[2] && li[2][:link_html]) ? li[2][:link_html] : {}
      li_options = (li[2] && li[2][:li_html]) ? li[2][:li_html] : {}

      active_class = (current_page? li[1].gsub(/#.*/, '') ) ? "active" : ""

      li_css_class = []
      li_css_class << li_options[:class] if li_options[:class]
      li_css_class << active_class
      li_options[:class] = li_css_class.join(" ")

      li_link << content_tag(:li, link_to(li[0], li[1], link_options), li_options)
    end

    content_tag(:ul, li_link.join.to_s.html_safe, options)
  end

  def render_icon_with_text(icon, text, options = {})
    css_class = []
    css_class << options[:class] if options[:class]
    css_class << 'text'
    options[:class] = css_class.join(" ")

    raw "#{render_icon(icon, options)}#{text}"
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
    content_tag(:div, render_mute(text), class: 'well well-white') if obj.nil? || obj.empty?
  end

  def render_mute(text)
    content_tag(:h3, text, class: "text-muted text-center")
  end

  def render_disabled_input(attribute)
    text_field_tag nil, attribute, class: 'form-control', disabled: true
  end

  def render_root_input_lg
    ' input-lg' if current_page? root_path
  end

  def edit_action?
    params[:action] == 'edit'
  end

  def is_remote?(type)
    type.to_sym == :remote
  end

  private

    def alert_notice_tag(type, msg)
      content_tag(:div, notice_content_with_close(msg),
        class: "alert alert-#{type} alert-dismissible",
        role: :alert
      )
    end

    def notice_content_with_close(msg)
      content_tag(:button, span_close,
        type: :button, class: :close,
        data: { dismiss: :alert }, aria: { label: :Close }
      ) +
      content_tag(:strong, msg)
    end

    def span_close
      content_tag(:span, raw("&times;"), aria: { hidden: true })
    end
end
