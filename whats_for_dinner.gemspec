Gem::Specification.new do |s|
  s.name        = 'whats-for-dinner'
  s.version     = '1.0.0'
  s.licenses    = ['None']
  s.executables << 'whats-for-dinner'
  s.summary     = "What's For Dinner?"
  s.description = "A simple gem to help groups find restaurants that optimize their collective preferences."
  s.authors     = ["Adam Fraser"]
  s.email       = 'adam.fraser@gmail.com'
  s.files       = 
    [
      "bin/whats-for-dinner",
      "lib/category.rb",
      "lib/category_list.rb",
      "lib/command_line_interface.rb",
      "lib/restaurant.rb",
      "lib/user.rb",
      "lib/whats_for_dinner.rb",
      "lib/yelp_client.rb"
    ]
  s.homepage    =
    'https://github.com/adamgfraser/whats-for-dinner'
end