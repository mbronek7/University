# frozen_string_literal: true

require 'set'

def set_dictionary
  s = Set.new
  File.foreach('polish_words.txt') do |line|
    s << line.strip
  end
  s.delete("")
  s
end
