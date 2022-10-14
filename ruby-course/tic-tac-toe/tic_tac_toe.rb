# frozen_string_literal: true

# The main class
class Game
  private

  attr_reader :board
  attr_accessor :active_player

  def initialize
    puts 'WELCOME TO TIC TAC TOE!'
    @active_player = 1
    @board =
      [[' ', ' ', ' '],
       [' ', ' ', ' '],
       [' ', ' ', ' ']]
    display
    input
  end

  def display
    puts 'Board state:'
    board.each do |row|
      row = row.map do |cell|
        ['|', cell, '|'].join
      end
      row = row.join(' ')
      puts row
    end
  end

  def put(number)
    number -= 1
    x = number / 3
    y = number % 3
    if board[x][y] != ' '
      puts 'that square is already taken'
    else
      board[x][y] = get_player_token
      display
      if check_lines(x, y)
        puts "PLAYER #{active_player} WON!"
        return
      end
      @active_player = active_player % 2 + 1

    end
    input
  end

  def input
    loop do
      puts "PLAYER #{active_player}: ENTER A NUMBER BETWEEN 1 AND 9"
      x = gets.chomp
      if verify(x)
        put(x.to_i)
        return
      end
    end
  end

  def verify(num)
    unless num.to_i.to_s == num
      puts "your input wasn't a integer"
      return false
    end
    num = num.to_i
    unless num.positive? && num < 10
      puts "your input wasn't between 1 and 9"
      return false
    end
    true
  end

  def check_lines(x, y)
    is_inside_main_diagonal = x == y
    is_inside_secondary_diagonal = (x + y == 2)
    # check horizontal
    return true if board[x].uniq.length == 1
    # check vertical
    return true if [board[0][y], board[1][y], board[2][y]].uniq.length == 1
    # check main diagonal if inside
    return true if is_inside_main_diagonal && [board[0][0], board[1][1], board[2][2]].uniq.length == 1
    # check secondary diagonal if inside
    return true if is_inside_secondary_diagonal && [board[2][0], board[1][1], board[0][2]].uniq.length == 1
  end

  def get_player_token
    active_player == 1 ? 'X' : 'O'
  end
end

Game.new
