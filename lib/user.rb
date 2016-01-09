class User
  attr_accessor :name, :likes, :dislikes

  @@all = []

  def initialize(name, likes, dislikes)
    @name = name
    @likes = likes.map {|title| Category.find_by_title(title)}
    @dislikes = dislikes.map {|title| Category.find_by_title(title)}
    @@all << self
  end

  def self.all
    @@all
  end

end