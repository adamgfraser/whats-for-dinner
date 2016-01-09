class User
  attr_accessor :name, :likes, :dislikes

  @@all = []

  def initialize(name, likes, dislikes)
    @name = name
    @likes = likes
    @dislikes = dislikes
    @@all << self
  end

  def self.all
    @@all
  end

end