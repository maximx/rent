module ToursHelper
  def render_tours_prev_link(path)
    link_to raw(t('helpers.tours.previous')), path, class: 'btn btn-lg btn-default pull-left'
  end

  def render_tours_next_link(path)
    link_to raw(t('helpers.tours.next')), path, class: 'btn btn-lg btn-default pull-right'
  end

  def render_tours_title
    content_tag :h1, t("controller.tours.action.#{action_name}"), class: 'text-center'
  end

  def render_tours_last_next_path
    user_signed_in? ? tours_path : new_user_registration_path
  end
end
