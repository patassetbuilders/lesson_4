require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # col
                [[1, 5, 9], [3, 5, 7]] # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd, computer, player)
  system 'clear'
  prompt("Play Tic Tac Toe best of five wins.")
  prompt("Current score computer #{computer} player #{player}")
  prompt('Computer is O you are X')
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = INITIAL_MARKER }
  board
end

def empty_square(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(brd) # improves layout of empty square
  array_length = empty_square(brd).size
  if array_length > 1
    first_string = empty_square(brd)[0..(array_length - 2)].join(',')
    second_string = " or #{empty_square(brd).last}"
  return first_string + second_string
else
    return empty_square(brd).last.to_s
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt("Choose a square #{joinor(brd)} ")
    square = gets.chomp.to_i
    break if empty_square(brd).include?(square)
    prompt("This is not a valid choice")
  end
  brd[square] = PLAYER_MARKER
end

def at_risk_square?(brd)
  at_risk_square = 0
  # if the computer already has two squares in a row go for the third
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2
      line.each do |square|
        if brd[square] == INITIAL_MARKER
          at_risk_square = square
          return at_risk_square
        end
      end
    end
  end
  nil
end

def has_advantage_square?(brd)
  has_advantage_square = 0
  # if the computer already has two squares in a row go for the third
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2
      line.each do |square|
        if brd[square] == INITIAL_MARKER
          has_advantage_square = square
          return has_advantage_square
        end
      end
    end
  end
  nil
end

def computer_places_piece!(brd)
  if empty_square(brd).include?(5)
    square = 5
  elsif has_advantage_square?(brd)
    square = has_advantage_square?(brd)
  elsif at_risk_square?(brd)
    square = at_risk_square?(brd)
  else
    square = empty_square(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_square(brd).size == 0
end

def somebody_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if  brd[line[0]] == PLAYER_MARKER &&
        brd[line[1]] == PLAYER_MARKER &&
        brd[line[2]] == PLAYER_MARKER
      return 'You'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      # note could have also used splat operator
      # brd.values_at(*line).count( COMPUTER_MARKER ) == 3
      return 'Computer'
    end
  end
  nil
end


player = 0 #score
computer = 0
loop do #play again loop
  while player < 5 || computer < 5 do #best of five loop 
  board = initialize_board
  display_board(board, computer, player)
  prompt("\n")
  
  
    loop do
      player_places_piece!(board)
      display_board(board, computer, player)
      computer_places_piece!(board)
      display_board(board, computer, player)
      break if board_full?(board) || somebody_won?(board)
    end
   
    if somebody_won?(board)
      prompt "#{detect_winner(board)} won!"
      if detect_winner(board) == 'Computer'
        computer += 1
      else
        player += 1
      end
      prompt("Current score computer #{computer} player #{player}")
      prompt('Next game')
      gets 
    else
      prompt('Its a tie')
      prompt("Current score computer #{computer} player #{player}")
      prompt('Next game')
      gets
    end
  end
    prompt('Would you like to play again? Y / N')
    play_again = gets.chomp.downcase
    if play_again != 'y'
      player = 0 #score
      computer = 0
      break
    end
end
'Thank you for playing Tic Tack Toe'
