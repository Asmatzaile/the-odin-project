def fibs(number)
  array = []

  number.times do
    array <<
      case array.length
      when 0
        0
      when 1
        1
      else
        array[-2] + array[-1]
      end
  end
  array
end

def fibs_rec(number, array = [])
  case number
  when 0
    array.push(0)
  when 1
    array.push(0, 1)
  else
    previous_array = fibs_rec(number - 1, array)
    array.push(previous_array[-2] + previous_array[-1])
  end
  array
end
p fibs_rec(8)
