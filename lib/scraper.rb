require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    response = Nokogiri::HTML(open(index_url))
    student_array = []
    response.css(".student-card a").each do |a|
      student_hash = {}
      student_hash[:name] = a.css(".card-text-container h4").text
      student_hash[:location] = a.css(".card-text-container p").text
      student_hash[:profile_url] = a.attribute("href").value
      student_array << student_hash
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    response = Nokogiri::HTML(open(profile_url))
    social_media = response.css(".social-icon-container a")
    student_hash = {}
    social_media.each do |v|
    string = v.attribute("href").value
    if string.match("twitter")
      student_hash[:twitter] = string
    elsif string.match("linkedin")
      student_hash[:linkedin] = string
    elsif string.match("github")
      student_hash[:github] = string
    elsif string.match("http")
      student_hash[:blog] = string
    end
    end
    student_hash[:profile_quote] = response.css(".vitals-text-container .profile-quote").text
    student_hash[:bio] = response.css(".description-holder p").text
    student_hash
  end

end

