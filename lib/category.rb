require 'json'

class Category
  attr_reader :title, :parents, :filter, :restaurants

  @@all = []

  def initialize(attributes)
    @title = attributes["title"]
    @parent = attributes["parents"]
    @filter = attributes["alias"]
    @restaurants = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.batch_create_from_file(path = "fixtures/categories.json")
    file = File.read(path)
    json = JSON.parse(file)
    categories = json.select do |category|
      category["parents"].include?("restaurants") &&
      !(category.has_key?("country_blacklist") && category["country_blacklist"].include?("US")) &&
      !(category.has_key?("country_whitelist") && !category["country_whitelist"].include?("US"))
    end
    categories += json.select do |category|
      category["parents"].find {|parent| categories.map{|category| category["alias"]}.include?(parent)} &&
      !(category.has_key?("country_blacklist") && category["country_blacklist"].include?("US")) &&
      !(category.has_key?("country_whitelist") && !category["country_whitelist"].include?("US"))
    end
    categories.sort_by! {|category| category["alias"]}
    categories.map {|category| Category.new(category)}
  end

  def self.find_by_title(title)
    self.all.find {|category| category.title.downcase == title.downcase }
  end

end