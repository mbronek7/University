# frozen_string_literal: true
require 'set'
require 'pry'
require 'byebug'
MAX_LENGTH = 34

def max(a, b)
  a > b ? a : b
end

def min(a, b)
  a < b ? a : b
end

# bool, text[array], size
def find_words(text, dictionary)
  return [true, [], 0] if text == ''

  if text.size == 1
    if dictionary.include?(text)
      return [true, [text], 1]
    else
      return [false, [], 0]
    end
  end

  return [true, [text], text.size**2] if dictionary.include?(text)

  mid = text.size / 2

  max_complete = false
  max_list = []
  max_val = 1

  start_point = max(0, mid - MAX_LENGTH)
  end_point = mid + 3
  end_search = min(mid + MAX_LENGTH, text.size)

  (start_point..end_point).each do |i|
    (mid..end_search).each do |j|
      break if j - i >= MAX_LENGTH
      if dictionary.include?(text[i..j-1])
        left_done, left_list, left_max = find_words(text[0..i-1], dictionary) if i > 0
        if left_done
          right_done, right_list, right_max = find_words(text[j..], dictionary) if j <= text.size
          if right_done
            if max_complete == false
              max_complete = true
              max_list = left_list + [text[i..j-1]] + right_list
              max_val = left_max + text[i..j-1].size**2 + right_max

            elsif max_val < left_max + text[i..j-1].size**2 + right_max
              max_list = left_list + [text[i..j-1]] + right_list
              max_val = left_max + text[i..j-1].size**2 + right_max
            end
          end
        end
      end
    end
  end
  [max_complete, max_list, max_val]
end

def insert_spaces(text, dictionary)
  check, words, val = find_words(text, dictionary)
  return words if words
end
