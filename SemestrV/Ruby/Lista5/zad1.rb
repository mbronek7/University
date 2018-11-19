# frozen_string_literal: true

require "open-uri"
require "nokogiri"
require "mechanize"

class Pages
  def initialize(page_url)
    @page_url = page_url
    @cache = []
  end

  attr_accessor :page_url, :cache

  def przeglad(start_page, depth, block)
    return if @cache.include?(start_page)
    @cache.push(start_page)
    to_visit = []
    puts "\nI am visiting #{start_page}\n\n"
    block.call start_page
    return if depth.zero?
    agent = Mechanize.new
    page = agent.get(start_page)
    page.links.each do |link|
      link = link.href
      link = start_page + link if link[0] == "/"
      to_visit.push(link)
    end
    to_visit.each { |l| przeglad(l, depth - 1, block) }
  rescue StandardError
  end

  def page_weight(page_url = @page_url)
    page = Nokogiri::HTML(open(page_url))
    look_for = %w(img applet video canvas audio)
    look_for.each do |element|
      p "Number of #{element} in this page is #{page.css(element).size}"
    end
  end

  def page_summary(page_url = @page_url)
    page = Nokogiri::HTML(open(page_url))
    meta = page.css("meta")
    meta.each do |element|
      puts "#{element.attributes["name"]&.value} - #{element.attributes["content"]&.value}"
    end
  end
end

block = proc { |page|
  puts Pages.new(page).page_weight
  Pages.new(page).page_summary
}

page = Pages.new("http://www.ii.uni.wroc.pl")
page.przeglad("http://www.ii.uni.wroc.pl", 1, block)
