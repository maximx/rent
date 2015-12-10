module Account::VectorsHelper
  def render_destroy_vector_link(vector)
    text = vector.name +
           link_to(raw(' &times;'),
                   account_subcategory_vector_path(vector.subcategory, vector),
                   method: :delete, class: 'badge', remote: true)
    content_tag :div,
                raw(text),
                class: 'label label-default tag-label', data: { vector: vector.id }
  end
end
