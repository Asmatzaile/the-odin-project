# frozen_string_literal: true

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
      return @current_index if @current_node.nil?

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

  def shift
    return if head.nil?

    @head = head.next_node
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
    # this implementation was done to allow immutable strings
    string_array = []
    init_pointers
    loop do
      break string_array << 'nil' if @current_node.nil?

      string_array << ['(', @current_node, ')', '->']
      @current_node = @current_node.next_node
    end
    string_array.join(' ')
  end

  def insert_at(value, index)
    return prepend(value) if index.zero?
    return 'Index too high' if index > size
    return append(value) if index == size

    new_node = Node.new(value, index)
    new_node.next_node = at(index)
    at(index - 1).next_node = new_node
  end

  def remove_at(index)
    return shift if index.zero?
    return 'Index too high' if index > size
    return pop if index == size - 1

    at(index - 1).next_node = at(index + 1)
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
my_list.append(1)
my_list.append(2)
my_list.append(3)
my_list.append(4)
puts my_list
my_list.insert_at('inserted', 5)
puts my_list
