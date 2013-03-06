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
    reject!(&:blank?)
    map!(&:strip)
    uniq!
  end
end
