# frozen_string_literal: true

require_relative 'init.rb'
require_relative 'words.rb'

dictionary = set_dictionary

File.foreach('zad2_input.txt') do |line|
  words_array = insert_spaces(line.strip, dictionary)
  File.open('zad2_output.txt', 'a') do |f|
    f.write(words_array.join(" "))
    f.write("\n")
  end
end
