# frozen_string_literal: true

# Clase
class Game
  def initialize
    file = File.open('google-10000-english-no-swears.txt')
    @dictionary = []
    @dictionary.push(file.readline.strip) until file.eof? # readlines messed up with gets and I had to use $stdin.gets every time I wanted to use it.
    newgame
  end

  def newgame
    @word = select_word(@dictionary)
    @wrong_letters = []
    @correct_letters = []
    @lives = 12
    play
  end

  def select_word(dictionary, min_length = 5, max_length = 12)
    word = ''
    until word.length.between?(min_length, max_length)
      index = rand(dictionary.length)
      word = dictionary[index].strip
    end
    word.split('')
  end

  def play
    loop do
      break puts "You lost!. The word was #{@word}" if @lives.negative?

      display_stats
      break puts 'You won!' unless @display.include?('_')

      # maybe win condition should be determined in another way;
      # I don't think display should be a class variable.

      guess = ask_input

      check_guess(guess)
    end
    newgame if prompt_replay
  end

  def display_stats
    @display = cypher(@word, @correct_letters).join(' ')
    puts "Lives left: #{@lives}"
    puts "Wrong letters: #{@wrong_letters.join(', ')}"
    puts "Word: #{@display}"
  end

  def check_guess(guess)
    if @word.include? guess
      puts 'Yay!'
      @correct_letters.push(guess)
    else
      @wrong_letters.push(guess)
      puts 'Oops!'
      @lives -= 1
    end
  end

  def prompt_replay
    loop do
      puts 'Do you want to play another game? (Y/n)'
      input = gets.chomp.downcase
      return true if input == 'y'
      return false if input == 'n'

      puts 'Wrong input'
    end
  end

  def cypher(word, correct_letters)
    word.map do |letter|
      correct_letters.include?(letter) ? letter : '_'
    end
  end

  def ask_input
    puts 'Enter your guess'
    input = $stdin.gets.chomp.to_s.downcase

    validate_input(input)
  end

  def validate_input(input)
    if input.match?(/^[a-z]$/)
      return input unless @wrong_letters.include?(input) || @correct_letters.include?(input)

      puts "You already guessed #{input}."
    else
      puts 'Wrong input'
    end
    ask_input
  end
end

Game.new
