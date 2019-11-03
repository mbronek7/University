# frozen_string_literal: true

require_relative 'poker.rb'
require_relative 'init.rb'

figurant_number_of_wins = 0
blotkarz_number_of_wins = 0

(1..NumberOfTests).each do |_test|
  figurant_cards = FigurantWaist.sample(5)
  blotkarz_cards = BlotkarzWaist.sample(5).sort_by(&:card)
  f, b = play(figurant_cards, blotkarz_cards)
  figurant_number_of_wins += f
  blotkarz_number_of_wins += b
end

print('szansa na wygrana figuranta:', figurant_number_of_wins / 10_000.0 * 100.0, '%')
puts
print('szansa na wygrana blotkarza:', blotkarz_number_of_wins / 10_000.0 * 100.0, '%')
