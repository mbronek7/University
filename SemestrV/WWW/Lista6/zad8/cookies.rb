# frozen_string_literal: true

require "selenium-webdriver"

@driver = Selenium::WebDriver.for :chrome

@driver.get("https://www.google.pl/search?client=opera&q=rajba+uwr&sourceid=opera&ie=UTF-8&oe=UTF-8")

@driver.manage.all_cookies.each do |cookie|
  puts cookie
end
