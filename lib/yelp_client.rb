require 'nokogiri'
require 'yelp'

class YelpClient
  attr_reader :client

  def initialize
    html = File.read("fixtures/api_keys.html")
    doc = Nokogiri::HTML(html)
    @client = Yelp::Client.new
    client.configure do |config|
      config.consumer_key = doc.css("td")[0].text
      config.consumer_secret = doc.css("td")[1].text
      config.token = doc.css("td")[2].text
      config.token_secret = doc.css("td")[3].text
    end
  end

  def search(location, params = {}, locale = {})
    client.search(location, params, locale).businesses
  end

end