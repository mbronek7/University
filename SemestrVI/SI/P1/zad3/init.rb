# frozen_string_literal: true

NumberOfTests = 10_000
DECK = %w(pik kier karo trefl).freeze
FigurantBase = %w(as krol dama walet).freeze
BlotkarzBase = %w(2 3 4 5 6 7 8 9 10).freeze
AllCards = %w(2 3 4 5 6 7 8 9 10 walet dama krol as).freeze
BlotkarzWinnings = 0
FigurantWinnings = 0
Variant = Struct.new(:card, :color)

def figurant_waist
  waist = []
  FigurantBase.each do |card|
    DECK.each do |color|
      waist << Variant.new(card, color)
    end
  end
  waist
end

def blotkarz_waist
  waist = []
  BlotkarzBase.each do |card|
    DECK.each do |color|
      waist << Variant.new(card, color)
    end
  end
  waist
end

FigurantWaist = figurant_waist
BlotkarzWaist = blotkarz_waist
