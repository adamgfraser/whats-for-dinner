require_relative 'user'
require_relative 'category'
require_relative 'whats_for_dinner'

class CommandLineInterface

  CATEGORIES = Category.batch_create_from_file

  def run
    location = get_location
    users = get_users
    recommendation = WhatsForDinner.ask(location, users)
    make_recommendation(recommendation)
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
      puts "Is anyone else joining you?"
      break unless has_next_user?(gets)
    end
    users
  end

  def make_recommendation(recommendation)
    puts "Let's go to #{recommendation}."
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
          validated_categories << get_preferences(recover_category)
        end
      end
      validated_categories.uniq
    end
  end

  def suggested_categories(input, categories = CATEGORIES, characters = 0)
    suggestions = categories
      .select {|category| category.title.downcase[0, characters] == input.downcase[0, characters]}
      .compact
    if suggestions.empty? || suggested_categories(input, suggestions, characters + 1).empty?
      suggestions
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

  def has_next_user?(input)
    case input.strip.downcase
    when "yes"
      true
    when "no"
      false
    else
      puts "I'm sorry, I didn't understand you.  Please say \"Yes\" or \"No\"."
      has_next_user?(gets)
    end
  end

end

CommandLineInterface.new.run