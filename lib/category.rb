class Category
  attr_accessor :title, :parents, :filter, :restaurants

  @@all = []

  def initialize(attributes)
    @title = attributes[:title]
    @parent = attributes[:parents]
    @filter = attributes[:alias]
    @restaurants = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.get_category_list
    categories = CATEGORY_LIST.select do |category|
      category[:parents].include?("restaurants") &&
      !(category.has_key?(:country_blacklist) && category[:country_blacklist].include?("US")) &&
      !(category.has_key?(:country_whitelist) && !category[:country_whitelist].include?("US"))
    end
    categories += CATEGORY_LIST.select do |category|
      category[:parents].find {|parent| categories.map{|category| category[:alias]}.include?(parent)} &&
      !(category.has_key?(:country_blacklist) && category[:country_blacklist].include?("US")) &&
      !(category.has_key?(:country_whitelist) && !category[:country_whitelist].include?("US"))
    end
    categories.sort_by! {|category| category[:alias]}
    categories.map {|category| Category.new(category)}
  end

  def self.find_by_title(title)
    self.all.find {|category| category.title.downcase == title.downcase }
  end

end