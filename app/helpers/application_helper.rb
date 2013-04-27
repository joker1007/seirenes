module ApplicationHelper
  def link_to_twitter_auth
    if current_user.try(:bind_with?, :twitter)
      content_tag(:span, "Twitter連携済み")
    else
      link_to "Twitterと連携する", "/auth/twitter"
    end
  end

  def link_to_facebook_auth
    if current_user.try(:bind_with?, :facebook)
      content_tag(:span, "Facebook連携済み")
    else
      link_to "facebookと連携する", "/auth/facebook"
    end
  end
end
