def para(cards)
  temp = {}
  cards.each do |card|
    if temp[card.card]
      temp[card.card] += 1
      return true if temp[card.card] == 2
    else
      temp[card.card] = 1
    end
  end
  false
end

def dwie_pary(cards)
  temp = {}
  counter = 0
  cards.each do |card|
    if temp[card.card]
      temp[card.card] += 1
      counter += 1 if temp[card.card] == 2
    else
      temp[card.card] = 1
    end
  end
  return true if counter == 2
  false
end

def trojka(cards)
  temp = {}
  cards.each do |card|
    if temp[card.card]
      temp[card.card] += 1
      return true if temp[card.card] == 3
    else
      temp[card.card] = 1
    end
  end
  false
end

def strit(cards)
  cards = cards.map(&:card)
  (1..8).each do |index|
    return true if AllCards[index, 5] == cards
  end
  false
end

def kolor(cards)
  return true if cards.map(&:color).uniq.size == 1
  false
end

def full(cards)
  temp = {}
  dwojka = false
  trojka = false
  cards.each do |card|
    if temp[card.card]
      temp[card.card] += 1
    else
      temp[card.card] = 1
    end
  end
  temp.each do |_k, v|
    dwojka = true if v == 2
    trojka = true if v == 3
  end
  dwojka && trojka
end

def kareta(cards)
  temp = {}
  cards.each do |card|
    if temp[card.card]
      temp[card.card] += 1
      return true if temp[card.card] == 4
    else
      temp[card.card] = 1
    end
  end
  false
end

def poker(cards)
  kolor(cards) && strit(cards)
end

def play(figurant, blotkarz)
  return [0, 1] if poker(blotkarz)

  order_of_rules = %w(kareta full kolor strit trojka dwie_pary para).freeze

  order_of_rules.each do |rule|
    return [1, 0] if send(rule, figurant)
    return [0, 1] if send(rule, blotkarz)
  end
  [1, 0]
end