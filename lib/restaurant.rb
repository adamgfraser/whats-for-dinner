class Restaurant
  attr_accessor :id, :is_claimed, :is_closed, :name, :image_url, :url, :mobile_url, :phone, :display_phone, :review_count, :categories, :distance, :rating, :rating_img_url, :rating_img_url_small, :rating_img_url_large, :snippet_text, :snippet_image_url, :address, :display_address, :city, :state_code, :postal_code, :country_code, :cross_streets, :neighborhoods, :latitude, :longitude, :menu_provider, :menu_date_updated, :reservation_url, :eat24_url

  @@all = []

  def initialize(restaurant)
    location = restaurant.location
    coordinate = location.coordinate
    [restaurant, location, coordinate].each do |instance|
      instance.instance_variables.each do |variable|
        instance_has = instance.instance_variable_defined?(variable)
        self_has = self.instance_variables.find(variable)
        if instance_has && self_has
          self.instance_variable_set(variable, instance.instance_variable_get(variable))
        end
      end
    end
    @@all << self
  end

end