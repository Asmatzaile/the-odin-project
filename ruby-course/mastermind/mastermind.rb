# computer randomly selects the secret colors (6)
#human gets feedback: exactly correct or correct color but wrong space

module Helpers
  def count_elements(array)
    array.reduce(Hash.new(0)) do |hash, element, index|
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

class Game 
  include Helpers

  def initialize 
    # @code = Array.new(4) {rand(6)}
    @code = [3, 2, 2, 1]
  end

  def check(guess)

    code_available = count_elements(code)
    is_fully_right = array_elements_equal?(guess, code)

    guess.each_with_index do |element, index|
      code_available[element] -= 1 if is_fully_right[index]
    end

    feedback =
    guess.map.with_index do |element, index|
      next 'fully_right' if is_fully_right[index]
      next false unless code_available[element] > 0
      code_available[element] -= 1
      'semi_right'
    end
    p feedback
  end

  private
  attr_reader :code

end




game = Game.new
game.check([1, 2, 1, 9])