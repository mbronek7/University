# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'mechanize'

class Pages
  ALL_RESPONSE_CODE = %w(403 404 502)

  def initialize(page_url)
    @page_url = page_url
    @distance = 0
    @cache = []
    @check = false
  end

  attr_accessor :page_url, :distance, :end_page, :cache, :check

  def distance(page_b)
    @end_page = page_b
    p @distance if przeglad(@page_url)
  end

  private

  def przeglad(start_page)
    return if @cache.include?(start_page)
    @cache.push(start_page)
    to_visit = []
    puts "\nI am visiting #{start_page}\n\n"
    agent = Mechanize.new
    page = agent.get(start_page)
    page.links.each do |link|
      begin
        agent.click(link)
        url = agent.page.uri.to_s
        p url
        exit if url.eql?(@end_page)
        to_visit.push(url)
      rescue Mechanize::ResponseCodeError => e
        if ALL_RESPONSE_CODE.include? e.response_code
          []
        else
          retry
        end
      rescue SystemExit
        puts "FOUND IN DISTANCE: #{@distance}"
        exit
      end
    end
    @distance += 1
    to_visit.each { |l| przeglad(l) }
  end
end

page = Pages.new('http://www.ii.uni.wroc.pl/~marcinm/')
page.distance('https://zapisy.ii.uni.wroc.pl/courses/')
