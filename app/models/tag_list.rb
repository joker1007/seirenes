class TagList < Array
  def initialize(*args)
    add(*args)
  end

  def add(*names)
    concat(names)
    clean!
  end

  def to_tags
    map {|name| Tag.new(name: name)}
  end

  private
  def clean!
    replace(lazy.reject(&:blank?)
      .map(&:strip)
      .map {|tag| tag.tr('ａ-ｚＡ-Ｚ', 'a-zA-Z')}
      .map {|tag| tag.tr('０-９', '0-9')}
      .map {|tag| NKF.nkf("-wWX", tag)}
      .map(&:downcase)
      .map {|tag| tag.gsub(/db$/i, "DB")}
      .force.uniq)
  end
end
