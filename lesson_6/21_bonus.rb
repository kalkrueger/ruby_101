require 'pry'
def prompt(msg)
  puts "=> #{msg}"
end

def opening
  system 'clear'
  prompt "Welcome to 'Something 1', we are playing to #{WIN_NUM}."
  prompt "The first player to reach 5 hands will be the winner."
  prompt "Press enter to deal the first hand!"
  gets
end

CARDS = [
  { 'Ace' => 1 },
  { 'Two' => 2 },
  { 'Three' => 3 },
  { 'Four' => 4 },
  { 'Five' => 5 },
  { 'Six' => 6 },
  { 'Seven' => 7 },
  { 'Eight' => 8 },
  { 'Nine' => 9 },
  { 'Ten' => 10 },
  { 'Jack' => 10 },
  { 'Queen' => 10 },
  { 'King' => 10 }
]

SUITS = ['Clubs', 'Diamonds', 'Hearts', 'Spades']

def new_deck(deck)
  new_deck = []
  SUITS.each do |suit|
    CARDS.each do |card|
      new_deck << { suit: suit, card: card.keys[0], score: card.values[0] }
    end
  end
  new_deck.shuffle!
  deck.replace(new_deck)
end

def play_card_dealer(deck, hand, score)
  if score.sum < BREAK_NUM
    hand << deck.shift
    optimize_score(hand, score)
  end
end

def play_card_player(deck, hand, score)
  hand << deck.shift
  optimize_score(hand, score)
end

def display_hand(hand)
  hand.each do |h|
    puts h[:card].center(10)
    puts "of".center(10)
    puts h[:suit].center(10)
    puts "----------"
  end
end

def display_showing(dhand, phand)
  system 'clear'
  showing = dhand.drop(1)
  prompt "Dealer's Hand:"
  puts "----------"
  puts "Face Down".center(10)
  puts "----------"
  display_hand(showing)
  prompt "Player's Hand:"
  display_hand(phand)
end

def display_table(dhand, phand)
  system 'clear'
  prompt "Dealer's Hand:"
  display_hand(dhand)
  prompt "Player's Hand:"
  display_hand(phand)
end

def one_or_eleven(h, optimal_card_values)
  if optimal_card_values.sum > (WIN_NUM - 11)
    h[:score]
  else
    h[:score] + 10
  end
end

def ace?(h, optimal_card_values)
  if h[:card] == 'Ace'
    one_or_eleven(h, optimal_card_values)
  else
    h[:score]
  end
end

def optimize_score(hand, score)
  optimal_card_values = []
  hand.sort_by { |h| h[:score] }.reverse.each do |h|
    optimal_card_values << ace?(h, optimal_card_values)
  end
  score.replace(optimal_card_values)
end

def hit_stay(dscore, pscore)
  if busted?(dscore, pscore)
    answer = 's'
  else
    loop do
      prompt "Hit or Stay? (h/s)"
      answer = gets.chomp.downcase
      break if answer.start_with?("h", "s")
      prompt "That's not a valid choice."
    end
  end
  answer
end

def busted?(dealer, player)
  if dealer.sum > WIN_NUM && player.sum > WIN_NUM
    "Both Hands Busted!"
  elsif player.sum > WIN_NUM
    "Player Busted!"
  elsif dealer.sum > WIN_NUM
    "Dealer Busted!"
  end
end

def choose_winner(dscore, pscore)
  winner = nil
  if busted?(dscore, pscore)
    prompt busted?(dscore, pscore)
    winner = busted?(dscore, pscore)
  elsif dscore.sum > pscore.sum
    prompt "Dealer Wins!"
    winner = "Dealer"
  elsif pscore.sum > dscore.sum
    prompt "Player Wins!"
    winner = "Player"
  else
    prompt "It's a tie!"
  end
  winner
end

def display_scores(dscore, pscore)
  prompt "Dealer's Score is #{dscore.sum}"
  prompt "Player's Score is #{pscore.sum}"
end

def keep_score(dscore, pscore, overall_score)
  case choose_winner(dscore, pscore)
  when "Dealer Busted!"
    overall_score['Player'] += 1
  when "Player"
    overall_score['Player'] += 1
  when "Player Busted!"
    overall_score['Dealer'] += 1
  when "Dealer"
    overall_score['Dealer'] += 1
  end
  hands_won(overall_score)
end

def hands_won(overall_score)
  prompt "Dealer has won #{overall_score['Dealer']} hand(s)"
  prompt "Player has won #{overall_score['Player']} hand(s)"
end

def play_to_five(overall_score)
  winner = nil
  if overall_score.values.include?(5)
    overall_score.select do |k, v|
      winner = k if v == 5
    end
    prompt "Game over! #{winner} was the first to win five hands!"
  end
  winner
end

def play_again?
  prompt "Would you like to play again? (y/n)"
  answer = gets.chomp.downcase
  loop do
    if answer.start_with?('n') || answer.start_with?('y')
      break
    else
      prompt "That's not a valid choice. Please pick y or n."
      answer = gets.chomp.downcase
    end
  end
  answer
end

deck = []
WIN_NUM = 21
BREAK_NUM = (WIN_NUM - 4)

loop do
  overall_score = { "Player" => 0, "Dealer" => 0 }

  opening

  loop do
    new_deck(deck)
    players_hand = []
    players_score = []
    dealer_hand = []
    dealer_score = []

    loop do
      loop do
        break if deck.count <= 48
        system 'clear'
        play_card_dealer(deck, dealer_hand, dealer_score)
        play_card_player(deck, players_hand, players_score)
      end

      display_showing(dealer_hand, players_hand)
      prompt "Player's score is #{players_score.sum}"
      hands_won(overall_score)

      loop do
        h_or_s = hit_stay(dealer_score, players_score)
        if h_or_s.start_with?('s')
          break if dealer_score.sum >= BREAK_NUM
          play_card_dealer(deck, dealer_hand, dealer_score)
        elsif h_or_s.start_with?('h')
          play_card_dealer(deck, dealer_hand, dealer_score)
          play_card_player(deck, players_hand, players_score)
        end
        break if busted?(dealer_score, players_score) &&
                 dealer_score.sum >= BREAK_NUM
        display_showing(dealer_hand, players_hand)
        prompt "Player's score is #{players_score.sum}"
        hands_won(overall_score)
      end

      display_table(dealer_hand, players_hand)
      display_scores(dealer_score, players_score)
      keep_score(dealer_score, players_score, overall_score)
      break
    end

    break if play_to_five(overall_score)
    prompt "Press enter to deal the next hand!"
    gets
  end

  if play_again?.start_with?('n')
    prompt "Thanks for playing! Good bye."
    break
  end
end
