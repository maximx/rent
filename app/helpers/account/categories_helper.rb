module Account::CategoriesHelper
  def render_account_vector_selection_navtabs
    render_link_li class: 'nav nav-tabs', role: 'tablist' do |li|
      li << [ render_icon_with_text('paperclip', t('controller.account/categories.action.index')),
              account_categories_path ]
      li << [ render_icon_with_text('pushpin', t('controller.account/subcategories.action.index')),
              account_subcategories_path ]
    end
  end
end
