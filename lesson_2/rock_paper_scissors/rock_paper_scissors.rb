VALID_CHOICES = ['rock', 'paper', 'scissors']

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
    (first == 'scissors' && second == 'paper') ||
    (first == 'paper' && second == 'rock')
end

def  display_results(player, computer)
  if win?(player, computer)
    prompt "You win!"
  elsif player == computer
    prompt "It's a tie!"
  else
    prompt "Computer wins!"
  end
end

loop do
  choice = ''
  loop do
    prompt "Choose one: #{VALID_CHOICES.join(', ')}"
    choice = gets.chomp

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt "Thats not a valid choice."
    end
  end

  computer_choice = VALID_CHOICES.sample
  prompt "You chose #{choice} and computer chose #{computer_choice}"
  display_results(choice, computer_choice)

  prompt "Would you like to play again?"
  again = gets.chomp.downcase
  break unless again.start_with?('y')
end
