def merge_sort(array)
  # base case
  return array if array.length == 1

  # divide
  midpoint = (array.length-1)/2.floor
  left_array = array[0..midpoint]
  right_array = array[midpoint+1..-1]

  # conquer
  sorted_left = merge_sort(left_array)
  sorted_right = merge_sort(right_array)

  # combine
  sorted_complete = []
  until sorted_left.empty? || sorted_right.empty?
    sorted_complete << (
      (sorted_left[0] < sorted_right[0]) ?
      sorted_left.shift :
      sorted_right.shift
    )
  end
  sorted_complete.concat(sorted_left.empty? ? sorted_right : sorted_left)

  return sorted_complete
end

p merge_sort([1,9,2,8,3,7,6,5,4,0])
