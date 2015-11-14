module ProfilesHelper
  def profiles_controller?
    'profiles' == params[:controller]
  end

  def render_icon_confirmed
    render_icon('ok', class: 'text-success', data: { toggle: 'tooltip' }, title: '已驗證')
  end
end
