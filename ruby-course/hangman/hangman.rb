# frozen_string_literal: true

require 'yaml'
# Clase
class Game
  def initialize
    puts "===========
  HANGMAN
==========="
    if load_or_create == 'load'
      load_game
    else
      create_game
      play
    end
  end

  def load_or_create
    return 'create' unless check_saves

    loop do
      puts "Do you want to  1) Load a previous game
                2) Play a new game"
      input = gets.chomp
      return 'load' if input == '1'
      return 'create' if input == '2'

      'Wrong input'
    end
  end

  def check_saves
    Dir.exist?('saves') && !Dir.empty?('saves')
  end

  def create_game
    file = File.open('google-10000-english-no-swears.txt')
    dictionary = []
    dictionary.push(file.readline.strip) until file.eof? # readlines messed up with gets and I had to use $stdin.gets every time I wanted to use it.
    @word = select_word(dictionary)
    @wrong_letters = []
    @correct_letters = []
    @lives = 12
  end

  def save_game
    name = ''
    loop do
      puts 'Enter a name for your save:'
      name = gets.chomp
      break unless File.exist?("saves/#{name}")
      break if prompt_overwrite(name) == 'y'
    end
    Dir.mkdir('saves') unless Dir.exist?('saves')
    serialized_class = YAML.dump(self)
    File.write("saves/#{name}", serialized_class)
    puts 'Game saved!'
  end

  def prompt_overwrite(name)
    loop do
      puts "File \"#{name}\" already exists. Overwrite? (Y/n)"
      input = gets.chomp.downcase
      return input if %w[y n].include?(input)

      puts 'Wrong input'
    end
  end

  def load_game
    game_array = Dir.entries('saves')
    game_array.pop(2)
    puts 'Your saved games are:'
    game_array.each_with_index do |name, index|
      puts "#{index + 1}) \"#{name}\""
    end
    input = ''
    loop do
      puts 'Enter a number to load your game'
      input = gets.chomp
      break if input.to_i.to_s == input && input.to_i.between?(1, game_array.length)

      puts 'Wrong input'
    end
    save = File.open("saves/#{game_array[input.to_i - 1]}")
    YAML.load(save, permitted_classes: ['Game']).play
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
      if guess_or_save == 'guess'
        guess = ask_guess
        check_guess(guess)
      else
        save_game
      end
    end
    newgame if prompt_replay
  end

  def display_stats
    @display = cypher(@word, @correct_letters).join(' ')
    puts "Lives left: #{@lives}"
    puts "Wrong letters: #{@wrong_letters.join(', ')}"
    puts "Word: #{@display}"
  end

  def guess_or_save
    return 'guess' if (@wrong_letters + @correct_letters).empty?

    loop do
      puts 'Do you want to  1) Guess a letter
                2) Save the current game'
      input = gets.chomp
      return 'guess' if input == '1'
      return 'save' if input == '2'

      puts 'Wrong input'
    end
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

  def ask_guess
    puts 'Enter a letter'
    guess = gets.chomp.to_s.downcase

    validate_guess(guess)
  end

  def validate_guess(guess)
    if guess.match?(/^[a-z]$/)
      return guess unless (@wrong_letters + @correct_letters).include?(guess)

      puts "You already guessed #{guess}."
    else
      puts 'Wrong input'
    end
    ask_guess
  end
end

Game.new
