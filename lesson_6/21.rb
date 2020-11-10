def prompt(msg)
  puts "=> #{msg}"
end

deck = []

scores = [
  { ace: [1, 11] },
  { two: [2] },
  { three: [3] },
  { four: [4] },
  { five: [5] },
  { six: [6] },
  { seven: [7] },
  { eight: [8] },
  { nine: [9] },
  { ten: [10] },
  { jack: [10] },
  { queen: [10] },
  { king: [10] }
]

suits = [:clubs, :diamonds, :hearts, :spades]

def new_deck(deck, scores, suits)
  new_deck = []
  suits.each do |suit|
    scores.each do |card|
      new_deck << { suit => card }
    end
  end
  new_deck.shuffle!
  deck.replace(new_deck)
end

def play_card_dealer(deck, hand, score)
  if score.sum < 17
    hand << deck.shift
  end
  pick_score(hand, score)
end

def play_card_player(deck, hand, score)
  hand << deck.shift
  pick_score(hand, score)
end

def display_hand(hand)
  hand.each do |h|
    puts h.values[0].keys[0].to_s.capitalize.center(10)
    puts "of".center(10)
    puts h.keys[0].to_s.capitalize.center(10)
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

def pick_score(hand, score)
  best_score = []
  hand.sort_by { |h| h.values[0].values[0] }.reverse.each do |h|
    if best_score.flatten.sum > 10
      best_score << h.values[0].values[0].first
    else
      best_score << h.values[0].values[0].last
    end
  end
  score.replace(best_score)
end

def busted?(dealer, player)
  if dealer.sum > 21
    "Dealer Busted!"
  elsif player.sum > 21
    "Player Busted!"
  end
end

def choose_winner(dscore, pscore)
  winner = nil
  if busted?(dscore, pscore)
    prompt busted?(dscore, pscore).to_s
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
  prompt "Player has won #{overall_score['Player']} hand(s)"
  prompt "Dealer has won #{overall_score['Dealer']} hand(s)"
end

overall_score = { "Player" => 0, "Dealer" => 0 }

loop do
  new_deck(deck, scores, suits)
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

    loop do
      prompt "Hit or Stay? (h/s)"
      answer = gets.chomp.downcase
      if answer.start_with?('s')
        break if dealer_score.sum >= 17
        play_card_dealer(deck, dealer_hand, dealer_score)
        break if busted?(dealer_score, players_score)
        display_showing(dealer_hand, players_hand)
        prompt "Player's score is #{players_score.sum}"
      elsif answer.start_with?('h')
        play_card_player(deck, players_hand, players_score)
        break if busted?(dealer_score, players_score)
        play_card_dealer(deck, dealer_hand, dealer_score)
        break if busted?(dealer_score, players_score)
        display_showing(dealer_hand, players_hand)
        prompt "Player's score is #{players_score.sum}"
      else
        prompt "That's not a valid choice."
      end
    end
    display_table(dealer_hand, players_hand)
    display_scores(dealer_score, players_score)
    keep_score(dealer_score, players_score, overall_score)
    break
  end
  prompt "Keep playing? (y/n)"
  answer = gets.chomp.downcase
  break if answer.start_with?('n')
end
