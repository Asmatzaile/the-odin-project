# Linked list
class LinkedList
  attr_reader :head

  def initialize
    @head = nil
  end

  def init_pointers
    @current_node = head
    @current_index = 0
  end

  def move_to_next_node
    @current_node = @current_node.next_node
    @current_index += 1
  end

  def tail
    init_pointers
    tail_node = nil
    loop do
      break if @current_node.nil?

      tail_node = @current_node
      move_to_next_node
    end
    tail_node
  end

  def append(value)
    new_node = Node.new(value, nil)
    if tail.nil?
      @head = new_node
    else
      tail.next_node = new_node
    end
  end

  def prepend(value)
    new_node = Node.new(value, head)
    @head = new_node
  end

  def size
    init_pointers
    loop do
      return current_index if current_node.nil?

      move_to_next_node
    end
  end

  def at(index)
    init_pointers
    loop do
      return @current_node if @current_index == index || @current_node.nil?

      move_to_next_node
    end
  end

  def pop
    return if tail.nil?

    tail_index = find(tail.value)
    return @head = nil if tail_index.zero?

    at(tail_index - 1).next_node = nil
  end

  def contains?(value)
    !find(value).nil?
  end

  def find(value)
    init_pointers
    loop do
      return nil if @current_node.nil?
      return @current_index if @current_node.value == value

      move_to_next_node
    end
  end

  def to_s
    string = ''
    init_pointers
    loop do
      return string << 'nil' if @current_node.nil?

      string << "( #{@current_node} ) -> "
      @current_node = @current_node.next_node
    end
  end

  def insert_at(value, index)
    return prepend(value) if index.zero?
    return 'Index too high' if index > size
    return append(value) if index == size
    # queda x hacer...
  end

  def remove_at(index)
    return shift(value) if index.zero?
    return 'Index too high' if index > size
    return pop if index == size
    # queda x hacer...
  end
end

# Node
class Node
  attr_reader :value
  attr_accessor :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end

  def to_s
    value.to_s
  end
end

my_list = LinkedList.new
puts my_list
my_list.prepend('hello 1')
my_list.append('hello 2')
my_list.append('hello 3')
puts my_list

p my_list.find('hello 3')
p my_list.contains?('hello 3')
p my_list.contains?('hello 4')
puts my_list
my_list.pop
puts my_list
my_list.pop
puts my_list
my_list.pop
puts my_list
my_list.pop
puts my_list
