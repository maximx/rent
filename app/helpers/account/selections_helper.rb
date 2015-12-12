module Account::SelectionsHelper
  def render_destroy_selection_link(selection)
    text = selection.name +
           link_to(raw(' &times;'),
                   account_vector_selection_path(selection.vector, selection),
                   method: :delete, class: 'badge', remote: true,
                   data: { confirm: t('helpers.common.destroy_confirm') })
    content_tag :div,
                raw(text),
                class: 'label label-warning tag-label', data: { selection: selection.id }
  end
end
