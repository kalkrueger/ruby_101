INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
PLAYER_1 = 'choose' # choose, PLAYER_MARKER, or COMPUTER_MARKER

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

def choose
  answer = ''
  loop do
    prompt "Who do you want to go first? Player or Computer?"
    answer = gets.chomp.downcase
    if answer.start_with?('p')
      answer = PLAYER_MARKER
      break
    elsif answer.start_with?('c')
      answer = COMPUTER_MARKER
      break
    else
      prompt "Please choose a vaild option."
    end
  end
  answer
end

def whos_first
  turn = ''
  if PLAYER_1 == COMPUTER_MARKER
    turn = COMPUTER_MARKER
  elsif PLAYER_1 == PLAYER_MARKER
    turn = PLAYER_MARKER
  else
    turn = choose
  end
  turn
end

def whos_up(counter, first_up)
  turn = ''
  if counter.odd? && first_up == PLAYER_MARKER
    turn = COMPUTER_MARKER
  elsif counter.odd? && first_up == COMPUTER_MARKER
    turn = PLAYER_MARKER
  else
    turn = first_up
  end
  turn
end

def play_piece(turn, brd)
  turn = turn
  loop do
    display_board(brd)
    break if someone_won?(brd) || board_full?(brd)
    if turn == PLAYER_MARKER
      turn = COMPUTER_MARKER
      player_places_piece!(brd)
    elsif turn == COMPUTER_MARKER
      turn = PLAYER_MARKER
      computer_places_piece!(brd)
    end
  end
end

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
  square = nil
  WINNING_COMBOS.each do |line|
    square = attack(line, brd)
    break if square
  end
  if !square
    WINNING_COMBOS.each do |line|
      square = defend(line, brd)
      break if square
    end
  end
  square = valid_sqaures(brd).sample if !square
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

def defend(line, brd)
  if brd.values_at(*line).count(PLAYER_MARKER) == 2
    brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def attack(line, brd)
  if valid_sqaures(brd).include?(5)
    5
  elsif brd.values_at(*line).count(COMPUTER_MARKER) == 2
    brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def continue
  prompt "Press enter to continue"
  gets
end

loop do
  player_score = 0
  computer_score = 0
  counter = 0
  first_up = whos_first
  loop do
    board = initialize_board

    turn = whos_up(counter, first_up)

    play_piece(turn, board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won the game!"
    else
      prompt "It's a tie!"
    end

    counter += 1

    case detect_winner(board)
    when "Player"
      player_score += 1
    when "Computer"
      computer_score += 1
    end

    prompt "Player: #{player_score}, Computer: #{computer_score}"
    if player_score == 5 || computer_score == 5
      prompt "#{detect_winner(board)} won the series!"
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
