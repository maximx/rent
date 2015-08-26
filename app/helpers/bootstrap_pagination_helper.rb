module BootstrapPaginationHelper
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end

    unless options[:renderer]
      default_options = {
        class: "pagination",
        inner_window: 3,
        outer_window: 0,
        previous_label: t("will_paginate.previous_label"),
        next_label: t("will_paginate.next_label"),
        renderer: BootstrapPaginationHelper::LinkRenderer
      }

      default_options[:class] += " " + options[:class] if options[:class]

      options = options.merge(default_options)
    end

    super *[collection_or_options, options].compact
  end

  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    def prepare(collection, options, template)
      @link_html = options.delete(:link_html)
      @link_html.delete(:'data-remote') if !@link_html.nil? && @link_html[:'data-remote'] == false
      super
    end

    protected
      def page_number(page)
        unless page == current_page
          link(page, page, :rel => rel_value(page))
        else
          link(page, "#", :class => 'active')
        end
      end

      def gap
        text = @template.will_paginate_translate(:page_gap)
        tag(:li, tag(:a, text), class: "disabled")
      end

      def previous_or_next_page(page, text, classname)
        if page
          link(text, page, :class => classname)
        else
          link(text, "#", :class => classname + ' disabled')
        end
      end

      def html_container(html)
        tag(:div, tag(:ul, html, container_attributes), class: "pagination-wrapper")
      end

    private

      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          target = url(target)
        end

        classname = attributes[:class]
        attributes.delete(:classname)

        attributes[:href] = target unless target == "#"
        attributes.merge!(@link_html) unless @link_html.nil?

        tag(:li, tag(:a, text, attributes), :class => classname)
      end
  end
end
