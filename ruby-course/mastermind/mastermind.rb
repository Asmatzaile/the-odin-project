# frozen_string_literal: true

# Helper functions for Game class
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

# Main class
class Game
  include Helpers

  private

  def initialize
    @code = Array.new(4) { rand(6) }
    @number_of_guesses = 12
    play
  end

  def play
    puts inital_text
    number_of_guesses.times do |i|
      @guess_number = i + 1
      guess = ask_guess
      p feedback = check(guess)
      return puts 'You won!' if feedback.all?('fully_right')
    end
    puts 'You lost :('
  end

  def inital_text
    "======================
Welcome to MasterMind!
======================
Your goal is to crack the computer's code, which consists in four digits ranging from 0 to 5.
Each round, you will enter a code, and you will receive feedback on how well each digit resembles the computer's code.
  - 'fully_right': you matched the number and the position!
  - 'semi_right': you matched the number, but it is not in the correct position.
  - 'wrong': you didn't match the number. Better luck next time!
======================"
  end

  def ask_guess
    puts "Guess #{@guess_number}. #{number_of_guesses - @guess_number} guesses more remaining."
    puts 'Please enter your guess as a comma-separated list (e.g. 1, 2, 3, 4):'
    @input_array = gets.chomp.split(', ')
    return parse(@input_array) unless @input_array.length > 4

    wrong_input
  end

  def parse(array)
    array = array.map do |element|
      element_i = element.to_i
      break wrong_input unless element.to_i.to_s == element && element_i > -1 && element_i < 7

      element_i
    end
    (4 - array.length).times do
      array.push(-1)
    end
    array
  end

  def wrong_input
    puts "Wrong input: #{@input_array}"
    ask_guess
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

  attr_reader :code, :number_of_guesses
end

Game.new
