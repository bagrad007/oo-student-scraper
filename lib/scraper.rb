require "open-uri"
require "pry"
require "nokogiri"

class Scraper
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").collect do |student|
      hash = {}
      #name
      hash[:name] = student.css("h4.student-name").text
      #location
      hash[:location] = student.css(".student-location").text
      #profile url
      hash[:profile_url] = student.css("a").attr("href").value
      hash
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    hash = {}
    doc.css("div.main-wrapper").each do |profile|
      profile.css(".social-icon-container a").each do |element|
        if element.attr("href").include?("twitter")
          hash[:twitter] = element.attr("href")
        elsif element.attr("href").include?("linkedin")
          hash[:linkedin] = element.attr("href")
        elsif element.attr("href").include?("github")
          hash[:github] = element.attr("href")
        elsif element.attr("href").include?("http://")
          hash[:blog] = element.attr("href")
        end
      end

      if profile.css(".vitals-text-container").css(".profile-quote")[0].attr("class") == "profile-quote"
        hash[:profile_quote] = profile.css(".vitals-text-container").css(".profile-quote").text
      end

      if profile.css(".details-container").css(".description-holder p")
        hash[:bio] = profile.css(".details-container").css(".description-holder p").text
      end
    end
    hash
  end
end
