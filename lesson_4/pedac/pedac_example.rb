input = 4
arr = []
counter = 0
first_num = 0
row_len = 1

loop do
  row = []
  if input > counter
    loop do
      if row_len == row.length
        row_len += 1
        break
      else
        row << first_num += 2
      end
    end
    arr << row
    counter += 1
  else
    arr
    break
  end
end

puts arr.last.sum
