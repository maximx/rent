module ReviewsHelper
  def render_see_more_reviews(url, options = {})
    options.reverse_merge!( { remote: true, class: "btn btn-default col-lg-offset-5 user-reviews", role: "button" } )
    uri = URI.parse url
    link_to("+看更多", url, options) unless uri.query.nil?
  end
end
