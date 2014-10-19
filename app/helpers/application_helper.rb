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

  def order_by_select_tag
    select_tag "order_by", options_for_select([
      ["追加日(新しい順)", "created_at desc"],
      ["追加日(古い順)", "created_at asc"],
      ["投稿日(新しい順)", "nico_posted_at desc"],
      ["投稿日(古い順)", "nico_posted_at asc"],
      ["タイトル(昇順)", "raw_title asc"],
      ["タイトル(降順)", "raw_title desc"],
      ["マイリスト(多い順)", "nico_mylist_count desc"],
      ["マイリスト(少ない順)", "nico_mylist_count asc"]
    ], params[:order_by]), class: %w(form-control)
  end
end
