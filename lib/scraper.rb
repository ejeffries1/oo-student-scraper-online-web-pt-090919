#require 'nokogiri'
#require 'open-uri'
#require 'pry'

require_relative './student.rb'

class Scraper
  attr_accessor :name, :location, :profile_url, :twitter, :linkedin, :github, :youtube, :profile_quote

  def self.scrape_index_page(index_url)
    student_index = []
    html = index_url
    doc = Nokogiri::HTML(open(html))
    doc.css(".student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      info = {:name => name,
        :location => location,
        :profile_url => profile_url
      }
      student_index << info
      #binding.pry
    end
    student_index
  end

  def self.scrape_profile_page(profile_url)
    #html = profile_url
    doc = Nokogiri::HTML(open(profile_url))
    tag = doc.css(".vitals-container .social-icon-container a")
    student_hash = {}
    tag.each do |i|
      #binding.pry
      if i.attr("href").include?("twitter")
        student_hash[:twitter] = i.attr("href")
      elsif i.attr("href").include?("linkedin")
        student_hash[:linkedin] = i.attr("href")
      elsif i.attr("href").include?("github")
        student_hash[:github] = i.attr("href")
      elsif i.attr("href").include?("youtube")
        student_hash[:youtube] = i.attr("href")
      elsif i.attr("href").include?(".com/")
        student_hash[:blog] = i.attr("href")
      #elsif i.include?("profile_quote")
        #student_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile_quote").text
      end
      student_hash[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text
      student_hash[:profile_quote] = doc.css(".vitals-text-container .vitals-container .profile_quote").text
      #binding.pry
      end
      student_hash
    end
end
