module PasokaraDecorator
  def add_queue_link
    link_to "予約する",
      pasokara_song_queues_path(self),
      data: {
        method: :post,
        remote: true,
        type: :json,
        confirm: "「#{title}」を予約に追加しますか？"
      },
      class: ["btn", "btn-primary", "js-add_queue"]
  end

  def favorite_link(user)
    if user
      if favorited_by?(user)
        link_to "お気に入りを削除する",
          favorite_path(favorites.find {|f| f.user_id == user.id}),
          data: {
            remote: true,
            method: :delete,
            type: :json,
            confirm: "「#{title}」をお気に入りから削除しますか？",
          },
          class: ["btn", "btn-default", "js-remove_favorite"]
      else
        link_to "お気に入りに追加する",
          pasokara_favorites_path(self),
          data: {
            remote: true,
            method: :post,
            type: :json,
            confirm: "「#{title}」をお気に入りに追加しますか？"
          },
          class: ["btn", "btn-default", "js-add_favorite"]
      end
    end
  end

  def duration_str
    "#{(duration / 60)}:#{"%02d" % (duration % 60)}"
  end

  def nico_posted_at_for_info_box
    nico_posted_at.try(:strftime, "%Y/%m/%d %H:%M:%S")
  end

  def link_to_niconico(text = nil)
    text = nico_vid unless text
    link_to text, "http://www.nicovideo.jp/watch/#{nico_vid}"
  end
end
