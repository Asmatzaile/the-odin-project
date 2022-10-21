# frozen_string_literal: true

# Helper functions
module Helpers
  def count_elements(array)
    array.reduce(Hash.new(0)) do |hash, element|
      hash[element] += 1
      hash
    end
  end

  def array_elements_equal?(array1, array2)
    array1.map.with_index do |element, index|
      element == array2[index]
    end
  end
end

# Text storage
module Text
  TITLE =
'======================
Welcome to MasterMind!
======================'

  ASK_GAMEMODE =
'Do you want to:
  1. guess the code
  2. create the code?'

  HUMANGOAL_CRACK =
"Your goal is to crack the computer's code, which consists in four digits ranging from 0 to 5.
Each round, you will enter a code, and you will receive feedback on how well each digit resembles the computer's code.
  - 'fully_right': you matched the number and the position!
  - 'semi_right': you matched the number, but it is not in the correct position.
  - 'wrong': you didn't match the number. Better luck next time!"

  HUMANGOAL_CODE =
"Your goal is to write a code that the computer won't crack. The code must consist in four digits ranging from 0 to 5."
end

# Main class
class Game
  include Helpers

  private

  def initialize
    computer = Computer.new
    human = Human.new
    puts Text::TITLE
    puts Text::ASK_GAMEMODE
    @gamemode = human.ask_gamemode
    puts "You chose gamemode #{@gamemode}."
    set_roles(computer, human)
    @number_of_guesses = 12
    play
  end

  def set_roles(computer, human)
    if @gamemode == 1
      @coder = computer
      @guesser = human
      puts Text::HUMANGOAL_CRACK
    else
      @coder = human
      @guesser = computer
      puts Text::HUMANGOAL_CODE
    end
  end

  def play
    @code = coder.ask_code
    number_of_guesses.times do |i|
      guess_number = i + 1
      puts "Guess #{guess_number}. #{@number_of_guesses - guess_number} guesses more remaining."
      guess = guesser.ask_guess
      feedback = check(guess)
      guesser.feedback(feedback)
      return guesser.win if feedback.all?('fully_right')
    end
    guesser.lose
  end

  def check(guess)
    code_available = count_elements(code)
    is_fully_right = array_elements_equal?(guess, code)

    guess.each_with_index do |element, index|
      code_available[element] -= 1 if is_fully_right[index]
    end

    guess.map.with_index do |element, index|
      next 'fully_right' if is_fully_right[index]
      next 'wrong' unless code_available[element].positive?

      code_available[element] -= 1
      'semi_right'
    end
  end

  attr_reader :number_of_guesses, :code, :coder, :guesser
end

# Methods common to both human and computer
class Player
  def feedback(feedback)
    p feedback
  end
end

# Human methods
class Human < Player
  def wrong_input(callback)
    puts 'Wrong input.'
    callback.call
  end

  def ask_gamemode
    puts 'Please enter 1 or 2.'
    input = gets.chomp
    input_i = input.to_i
    if input_i.to_s == input && [1, 2].include?(input_i)
      input_i
    else
      wrong_input(method(:ask_gamemode))
    end
  end

  def ask_code
    puts 'Please enter the code as a comma-separated list (e.g. 0, 2, 3, 4):'
    input_array = gets.chomp.split(', ')
    if input_array.length <= 4 && input_array.all? { |x| x.to_i.to_s == x && x.to_i > -1 && x.to_i < 6 }
      input_array.map(&:to_i)
    else
      wrong_input(method(:ask_code))
    end
  end

  def ask_guess
    puts 'Please enter your guess as a comma-separated list (e.g. 0, 2, 3, 4):'
    input_array = gets.chomp.split(', ')
    if input_array.length > 4 && input_array.all? { |x| x.to_i.to_s == x && x.to_i  > -1 && x.to_i  < 6 }
      array = input_array.map(&:to_i)
      (4 - array.length).times { array.push(-1) }
      array
    else
      wrong_input(method(:ask_guess))
    end
  end

  def win
    puts 'You won!'
  end

  def lose
    puts 'You lost :('
  end
end

# Computer methods
class Computer < Player
  def initialize
    super
    @memo = Array.new(4)
  end

  def ask_code
    Array.new(4) { rand(6) }
  end

  # algorithm to crack the code
  def ask_guess
    @guess = @memo
    @guess = @guess.map { |x| x.nil? ? rand(6) : x }
    puts "Computer guessed #{@guess}"
    @guess
  end

  def feedback(feedback_arr)
    super
    right_pos_arr = feedback_arr.each_index.select { |i| feedback_arr[i] == 'fully_right' }
    right_pos_arr.each do |i|
      @memo[i] = @guess[i]
    end
  end

  def win
    puts 'Computer won'
  end

  def lose
    puts 'Computer lost :)'
  end
end

Game.new
