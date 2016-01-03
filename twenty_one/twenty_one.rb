require 'pry'

USED_CARDS = 'X'
UNUSED_CARDS = ''
PLAYER = 'P'
DEALER = 'D'

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  deck = {}
  suit =  %w( h d s c )
  picture = %w(J Q K a ) # a used for sorting, when evaluating hand I want to process aces last.
  suit.each do |suits|
    (2..9).each do |num|
      card = "#{num}#{suits}"
      deck[card] = UNUSED_CARDS
    end
    picture.each do |pict|
      card = "#{pict}#{suits}"
      deck[card] = UNUSED_CARDS
    end
  end
  deck
end

def sum_value_of(hand)
  sum = 0
  x = []
  picture = %w(J Q K)
  hand.each do |card|
    x << card[0..0]
  end
  x.sort.each do |card| # sort aces last
    if card.to_i > 0
      sum += card.to_i
    elsif picture.include? card
      sum += 10
    elsif  sum> 10 # processing aces last
      sum += 1
    else
      sum += 11
    end
  end
   sum
end

def unused(deck)
  deck.keys.select { |card| deck[card] == UNUSED_CARDS }
end

def players_hand(deck)
  deck.keys.select { |card| deck[card] == PLAYER }
end

def dealers_hand(deck)
  deck.keys.select { |card| deck[card] == DEALER }
end

def mark_used!(hand, deck)
  hand.each { |card| deck[card] = USED_CARDS }
end

def deal_player!(deck)
  deck[unused(deck).sample] = PLAYER
end

def deal_dealer!(deck)
  deck[unused(deck).sample] = DEALER
end

def display_hands(deck, count_players_hand, your_score, dealer_score)
  system 'clear'
  prompt("Play 21")
  prompt("YOU #{your_score}  V Dealer  #{dealer_score}") if your_score > 0 || dealer_score > 0
  prompt("Dealing cards")
  prompt("Players hand: #{players_hand(deck).join(', ')} count = #{count_players_hand}")
  prompt("Dealers hand: #{dealers_hand(deck).join(', ')}")
end

def hit_or_stay?
  loop do
    prompt('Would you like to HIT or STAY? Enter H or S')
    hit_or_stay = gets.chomp.downcase
    if %w( h s ).include? hit_or_stay
      return hit_or_stay
    else
      prompt("Sorry, that is not a valid choice")
    end
  end
end

deck = initialize_deck
your_score = 0
dealer_score = 0
# deal cards
while unused(deck).size > 10 # only one deck being used but ..
  # card counters dont get to see the last ten cards.
  count_players_hand = 0
  count_dealers_hand = 0
  2.times { deal_player!(deck) }
  count_players_hand = sum_value_of(players_hand(deck))
  1.times { deal_dealer!(deck) } # times unnecessary but included for readability IMHO
  count_dealers_hand = sum_value_of(dealers_hand(deck))
  display_hands(deck, count_players_hand, your_score, dealer_score)
  while hit_or_stay? != 's'
    deal_player!(deck)
    count_players_hand = sum_value_of(players_hand(deck))
    display_hands(deck, count_players_hand, your_score, dealer_score)
    break if count_players_hand > 21
  end
  prompt("Dealers count #{count_dealers_hand}")
  while count_dealers_hand <= 17
    deal_dealer!(deck)
    count_dealers_hand = sum_value_of(dealers_hand(deck))
  end
  # should line 126 to 136 be a method, it does three things
  # 1 determines who won the hand
  # 2 updates the overall game scores
  # 3 displays hands and hand values
  if count_players_hand < 22 && count_players_hand > count_dealers_hand ||
     count_players_hand < 22 && count_dealers_hand > 21
    your_score += 1
    display_hands(deck, count_players_hand, your_score, dealer_score)
    prompt("Dealers count #{count_dealers_hand}")
    prompt("Congratulations you win this round")
  else
    dealer_score += 1
    display_hands(deck, count_players_hand, your_score, dealer_score)
    prompt("Dealers count #{count_dealers_hand}")
    prompt("Dealer wins this round.")
  end
  prompt("Press 'Enter' to continue 'q' to quit")
  continue = gets.chomp.downcase
  break if continue == 'q' 
  mark_used!(players_hand(deck), deck)
  mark_used!(dealers_hand(deck), deck)
end
prompt("GAME OVER")
prompt("YOU #{your_score} :  Dealer  #{dealer_score}")
