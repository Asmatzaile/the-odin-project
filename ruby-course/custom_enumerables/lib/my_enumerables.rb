module Enumerable
  def my_each(&block)
    i = 0
    while i < length
      block.call(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index(&block)
    i = 0
    while i < length
      block.call(self[i], i)
      i += 1
    end
    self
  end

  def my_count(&block)
    return length unless block_given?

    i = 0
    count = 0
    while i < length
      count += 1 if block.call(self[i])
      i += 1
    end
    count
  end

  def my_map(&block)
    i = 0
    array = []
    while i < length
      array << block.call(self[i])
      i += 1
    end
    array
  end

  def my_select(&block)
    i = 0
    array = []
    while i < length
      array << self[i] if block.call(self[i])
      i += 1
    end
    array
  end

  def my_inject(initial_value, &block)
    i = 0
    result = initial_value
    while i < length
      result = block.call(result, self[i])
      i += 1
    end
    result
  end

  def my_all?(&block)
    i = 0
    while i < length
      return false unless block.call(self[i])

      i += 1
    end
    true
  end

  def my_none?(&block)
    i = 0
    while i < length
      return false if block.call(self[i])

      i += 1
    end
    true
  end

  def my_any?(&block)
    i = 0
    while i < length
      return true if block.call(self[i])

      i += 1
    end
    false
  end
end
