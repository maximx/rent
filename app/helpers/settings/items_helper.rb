module Settings::ItemsHelper

  def render_renting_checkbox(count)
    if count == 1
      content_tag(:span, "", class: "glyphicon glyphicon-ok")
    else
      content_tag(:span, "", class: "glyphicon glyphicon-unchecked")
    end
  end

end
