# frozen_string_literal: true

require "open-uri"
require "nokogiri"
require "mechanize"
require "benchmark"

class Pages
  def initialize(page_url)
    @page_url = page_url
    @cache = []
  end

  attr_accessor :page_url, :cache

  def page_summary(page_url = @page_url)
    page = Nokogiri::HTML(open(page_url))
    meta = page.css("meta")
    meta.each do |element|
      "#{element.attributes["name"]&.value} - #{element.attributes["content"]&.value}"
    end
  end
end

block = proc { |page|
  puts Pages.new(page).page_weight
  Pages.new(page).page_summary
}

pages = ["http://www.thecamels.org/", "http://ii.uni.wroc.pl/", "http://wp.pl/"]
threads = []
Benchmark.bm do |x|
  x.report do
    pages.each do |page|
      a = Pages.new(page)
      threads << Thread.new(a, &:page_summary)
    end
    threads.each(&:join)
  end
end

Benchmark.bm do |x|
  x.report do
    pages.each do |page|
      a = Pages.new(page)
      a.page_summary
    end
  end
end
