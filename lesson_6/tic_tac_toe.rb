require 'pry'
INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

WINNING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                 [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                 [[1, 5, 9], [3, 5, 7]]

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're an #{PLAYER_MARKER} and computer is an #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |  "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |  "
  puts "-----+-----+-----"
  puts "     |     |  "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |  "
  puts "-----+-----+-----"
  puts "     |     |  "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |  "
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = " " }
  new_board
end

def valid_sqaures(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, sym1 = ', ', sym2 = 'or')
  if arr.size < 3
    arr.join(" " + sym2 + " ")
  else
    arr[0..-2].join(sym1) + "#{sym1}#{sym2} #{arr[-1]}"
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Pick a square #{joinor(valid_sqaures(brd))}"
    square = gets.chomp.to_i
    break if valid_sqaures(brd).include?(square)
    prompt "That's not a valid square"
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = ''
  if defend(brd)[0]
    square = defend(brd)[0][0]
  else
    square = valid_sqaures(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  valid_sqaures(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_COMBOS.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def defend(brd)
  player_choices = brd.select{ |k, v| v == PLAYER_MARKER}.keys
  REMAINING_COMBOS.each do |arr|
    arr.delete_if { |n| player_choices.include?(n)}
  end
  REMAINING_COMBOS.select do
    |arr| arr.size == 1 && valid_sqaures(brd).include?(arr[0])
  end
end

def continue
  prompt "Press enter to continue"
  gets
end

loop do
  player_score = 0
  computer_score = 0
  loop do
    board = initialize_board

    REMAINING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                       [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                       [[1, 5, 9], [3, 5, 7]]

    loop do
      display_board(board)
      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won the match!"
    else
      prompt "It's a tie!"
    end

    case detect_winner(board)
    when "Player"
      player_score += 1
    when "Computer"
      computer_score += 1
    end

    prompt "Player: #{player_score}, Computer: #{computer_score}"
    if player_score == 5 || computer_score == 5
      prompt "#{detect_winner(board)} won the game!"
      break
    else
      continue
    end

  end

  prompt "Would you like to play again? (y/n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Goodbye."
