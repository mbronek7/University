def statystyka_slow(file_name)
  file = File.open(file_name, 'r')
  frequency = Hash.new(0)
  all_words = 0
  file.each_line do |line|
    words = line.scan(/\w+/)
    words.each do |word|
      all_words += 1
      frequency[word.downcase] += 1
    end
  end
  frequency.each do |element|
    p "#{element.first} - #{element[1] / all_words.to_f * 100}%"
  end
end
