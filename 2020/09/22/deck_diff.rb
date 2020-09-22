# cerner_2^5_2020

# expects brittly-named supporting files to be present
# save decks in Magic Arena format

def denumerize(arr)
  new_arr = []

  arr.each do |card|
    new_arr << card unless /(\d) (.+)/.match(card)

    $1.to_i.times { new_arr << $2 }
  end

  new_arr.sort
end

# https://stackoverflow.com/questions/38020334/ruby-array-intersection-with-duplicates
def intersection_with_duplicates(a, b)
  (a & b).flat_map { |card| [card] * [a.count(card), b.count(card)].min }
end

deck_a = File.readlines('2020/09/22/deck_a.txt')
deck_b = File.readlines('2020/09/22/deck_b.txt')

deck_a_deck = denumerize(deck_a.slice(0, deck_a.index("\n")).map(&:chomp) - ['Deck'])
deck_a_sideboard = denumerize(deck_a.slice(deck_a.index("\n") + 1, deck_a.length).map(&:chomp) - ['Sideboard'])

deck_b_deck = denumerize(deck_b.slice(0, deck_b.index("\n")).map(&:chomp) - ['Deck'])
deck_b_sideboard = denumerize(deck_b.slice(deck_b.index("\n") + 1, deck_b.length).map(&:chomp) - ['Sideboard'])

deck_diff = intersection_with_duplicates(deck_a_deck, deck_b_deck)
sideboard_diff = intersection_with_duplicates(deck_a_sideboard, deck_b_sideboard)

puts "the decks are #{deck_diff.length * 1.0 / deck_a_deck.length * 100}% similar"

puts '', "these are the #{deck_diff.length} mainboard cards in common:", deck_diff

puts '', "these are the #{sideboard_diff.length} sideboard cards in common:", sideboard_diff
