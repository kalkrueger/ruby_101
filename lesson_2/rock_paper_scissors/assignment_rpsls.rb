CHOICES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
SHORTHAND = []

CHOICES.each do |ch|
  if ch.start_with?('s')
    SHORTHAND << ch[0, 2]
  else
    SHORTHAND << ch[0]
  end
end

def convert_shorthand(sh)
  CHOICES[SHORTHAND.index(sh)]
end

winning_combos = {
  rock: [CHOICES[2], CHOICES[3]],
  paper: [CHOICES[0], CHOICES[4]],
  scissors: [CHOICES[1], CHOICES[3]],
  lizard: [CHOICES[1], CHOICES[4]],
  spock: [CHOICES[0], CHOICES[2]]
}

def prompt(message)
  puts "=> #{message}"
end

def win?(combos, first, second)
  combos[first.to_sym].include?(second)
end

def  results(combos, player, computer)
  if player == computer
    "That match is a tie!"
  elsif win?(combos, player, computer)
    "You win the match!"
  else
    "Computer wins the match!"
  end
end

player_score = 0
computer_score = 0

loop do
  while player_score < 5 && computer_score < 5
    player_choice = ''
    loop do
      choice_prompt = <<-MSG
        What is your weapon of choice?
        1.) Rock (R)
        2.) Paper (P)
        3.) Scissors (Sc)
        4.) Lizard (L)
        5.) Spock (Sp)
     MSG
      prompt choice_prompt
      player_choice = gets.chomp.downcase

      if CHOICES.include?(player_choice)
        break
      elsif SHORTHAND.include?(player_choice)
        player_choice = convert_shorthand(player_choice)
        break
      else
        prompt "Thats not a valid choice."
      end
    end

    computer_choice = CHOICES.sample
    prompt "You chose #{player_choice} and computer chose #{computer_choice}"
    display_results = results(winning_combos, player_choice, computer_choice)
    prompt display_results

    if display_results.include?('You')
      player_score += 1
    elsif display_results.include?('Computer')
      computer_score += 1
    end

    prompt "The score is Player: #{player_score} | Computer: #{computer_score}"
  end

  if player_score > computer_score
    prompt "You win the game!"
  else
    prompt "The Computer won the game! Better luck next time."
  end

  prompt "Would you like to play again?"
  again = gets.chomp.downcase
  break unless again.start_with?('y')
end
