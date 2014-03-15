module PasokaraDecorator
  def duration_str
    "#{(duration / 60)}:#{"%02d" % (duration % 60)}"
  end

  def link_to_niconico(text = nil)
    text = nico_vid unless text
    link_to text, "http://www.nicovideo.jp/watch/#{nico_vid}"
  end
end
