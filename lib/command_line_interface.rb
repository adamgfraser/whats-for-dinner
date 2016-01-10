class CommandLineInterface

  CATEGORIES = Category.get_category_list

  def run
    location = get_location
    users = get_users
    whats_for_dinner = WhatsForDinner.new(location, users)
    loop do
      restaurant = whats_for_dinner.ask
      make_recommendation(restaurant)
      break if yes?("Sound good?")
    end
    puts "Great!  Thanks for using What's For Dinner?, powered by Yelp."
  end

  def get_location
    puts "Hi!  Where do you want to have dinner tonight?"
    location = gets.strip
  end

  def get_users
    users = []
    loop do
      puts "What's your name?"
      name = gets.strip
      puts "What are you in the mood for today?"
      likes = get_preferences(gets)
      puts "What don't you want to eat?"
      dislikes = get_preferences(gets)
      user = User.new(name, likes, dislikes)
      users << user
      break unless yes?("Is anyone else joining you?")
    end
    users
  end

  def make_recommendation(restaurant)
    puts "How about?"
    puts ""
    puts restaurant.name
    puts "#{restaurant.rating} star rating, #{restaurant.review_count} reviews"
    puts restaurant.categories.map{|category| category.title}.join(", ")
    puts ""
    puts restaurant.display_address
    puts restaurant.display_phone
    puts ""
    puts "\"#{restaurant.snippet_text}\""
    puts ""
  end

  def get_preferences(input)
    validated_categories = []
    if input.strip == ""
      validated_categories
    else
      user_categories = input
        .split(/[,][ ]*/)
        .select {|string| !string.include? ","}
        .map {|string| string.strip}
      user_categories.each do |user_category|
        if CATEGORIES.map{|category| category.title.downcase}.include? user_category.downcase
          validated_categories << user_category.downcase
        else
          suggested_categories = suggested_categories(user_category).map{|category| category.title}
          formatted_categories = format_categories(suggested_categories)
          puts "I'm sorry, I didn't understand \"#{user_category}\".  Did you mean #{formatted_categories}?"
          recover_category = gets
            .split(/[,][ ]*/)
            .select {|string| !string.include? ","}
            .first
          get_preferences(recover_category).each {|category| validated_categories << category}
        end
      end
      validated_categories.uniq
    end
  end

  def suggested_categories(input, categories = CATEGORIES, characters = 1)
    suggestions = categories
      .select {|category| category.title.downcase[0, characters] == input.downcase[0, characters]}
      .compact
    if suggestions.empty?
      categories
    else
      suggested_categories(input, suggestions, characters + 1)
    end
  end

  def format_categories(array, string = "")
    head = "\"" + array[0].split.map{|word| word.capitalize}.join(" ") + "\""
    tail = array[1..-1]
    if tail.empty?
      string == ""? head : string + ", or " + head
    else
      string = string == ""? head : string + ", " + head
      format_categories(tail, string)
    end
  end

  def yes?(prompt)
    puts prompt
    case gets.strip.downcase
    when "yes"
      true
    when "no"
      false
    else
      puts "I'm sorry, I didn't understand you.  Please say \"Yes\" or \"No\"."
      yes?(prompt)
    end
  end

end