module Dashboard::ItemsHelper
  def render_renting_checkbox(count)
    if count == 1
      render_icon("ok")
    else
      render_icon("unchecked")
    end
  end
end
