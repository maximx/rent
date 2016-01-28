module SetCommonMetaTag
  extend ActiveSupport::Concern

  def set_title_meta_tag(options={})
    title = common_title options
    set_meta_tags title: title, og: {title: og_title(title)}
  end

  def meta_pagination_links(collection)
    meta_prev_page_link(collection)
    meta_next_page_link(collection)
  end

  private
    def common_title(options={})
      prefix = options.has_key?(:prefix) ? options[:prefix] : ''
      suffix = options.has_key?(:suffix) ? options[:suffix] : ''
      namespace = options[:namespace] ? controller_namespace : ''

      [
        namespace,
        prefix,
        t("controller.#{controller_path}.action.#{action_name}"),
        suffix
      ].join
    end

    def og_title(title)
      "#{title} - #{t('rent.site_name')}"
    end

    def controller_namespace
      namespace = controller_path.split('/').first
      t("controller.name.#{namespace}")
    end

    def meta_prev_page_link(collection)
      if collection.previous_page
        url_params = params.merge(page: collection.previous_page, only_path: false)
        url_params.delete(:page) if collection.previous_page == 1
        set_meta_tags prev: url_for(url_params)
      end
    end

    def meta_next_page_link(collection)
      if collection.next_page
        url_params = params.merge(page: collection.next_page, only_path: false)
        set_meta_tags next: url_for(url_params)
      end
    end
end
