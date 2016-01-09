class WhatsForDinner
  attr_accessor :location, :users, :yelp_client, :categories, :preferred_categories, :restaurants

  def initialize(location, users)
    @location = location
    @users = users
    @yelp_client = YelpClient.new
    @categories = Category.all
    @preferred_categories = []
    @restaurants = []
  end

  def ask
    if self.restaurants.empty?
      category_filters = get_category_filters
      self.categories = self.categories - self.preferred_categories
      params = {category_filter: category_filters}
      results = yelp_client.search(location, params)
      self.restaurants = results.map{|result| Restaurant.new(result)}
      if self.restaurants.empty?
        ask
      else
        recommendation = self.restaurants.first
        self.restaurants = self.restaurants[1..-1]
        recommendation
      end
    else
      recommendation = self.restaurants.first
      self.restaurants = self.restaurants[1..-1]
      recommendation
    end
  end

  def get_category_filters
    categories_with_votes = self.categories.map{|category| [category, 0]}.to_h
    users.each do |user|
      user.likes.each do |category|
        categories_with_votes[category] += 1 if categories_with_votes.has_key?(category)
      end
      user.dislikes.each do |category|
        categories_with_votes[category] -= 100 if categories_with_votes.has_key?(category)
      end
    end
    max_votes = categories_with_votes.values.max
    self.preferred_categories = categories_with_votes
      .select {|category, votes| votes == max_votes}
      .keys
    self.preferred_categories.map {|category| category.filter}.join(",")
  end

end