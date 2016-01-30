module ApplicationHelper
  def render_meta_tags
    display_meta_tags(
      site: t('rent.site_name'),
      keywords: t('rent.keywords'),
      description: t('rent.description').join,
      og: {
        site_name: t('rent.site_name'),
        type: 'website',
        image: asset_url('logo.png'),
        url: request.original_url,
        title: "#{t('rent.sub_title')} - #{t('rent.site_name')}",
        description: t('rent.description').join
      },
      reverse: true,
      viewport: "width=device-width, initial-scale=1",
      separator: raw("-")
    )
  end

  def render_navigation
    if account_settings_controller?
      render partial: 'common/navigation', locals: { list: account_settings_navbar_list }
    elsif account_manage_controller?
      render partial: 'common/navigation', locals: { list: account_manage_navbar_list }
    elsif ["notifications"].include? controller_path
      render partial: 'common/navigation', locals: { list: notifications_navbar_list }
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

      link_url = li[1]
      no_anchor_path = link_url.gsub(/#.*/, '')

      if li[2] and li[2][:parent]
        active_class = add_active_class?(no_anchor_path, li[2]) ? 'active' : ''
      else
        active_class = current_page?(no_anchor_path) ? 'active' : ''
      end
      link_url = li[2][:redirect_to] if li[2] and li[2].has_key?(:redirect_to) #/lender /borrower

      li_css_class = []
      li_css_class << li_options[:class] if li_options[:class]
      li_css_class << active_class
      li_options[:class] = li_css_class.join(" ")

      li_link << content_tag(:li, link_to(li[0], link_url, link_options), li_options)
    end

    content_tag(:ul, raw(li_link.join), options)
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
    content_tag(:div, render_mute(text), class: 'well') if obj.nil? || obj.empty?
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

  def render_currency_money(number)
    number = (number == number.to_i) ? number.to_i : number
    "$#{number}"
  end

  def mask(str)
    mask_str = str.slice(0)
    str[1..-1].size.times.each {mask_str += '*'}
    mask_str
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

    def add_active_class?(url, options={})
      exclusion = [options[:exclusion]].flatten
      request.fullpath.include?(url) and !exclusion.include?(request.fullpath)
    end
end
