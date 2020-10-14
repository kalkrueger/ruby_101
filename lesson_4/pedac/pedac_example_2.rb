def sum_input_row(input)
  arr = []
  row_len = 1
  base_integer = 0
  loop do
    arr << build_rows(row_len, base_integer)
    base_integer = arr.last.last
    break if row_len == input
    row_len += 1
  end
  p arr.last.sum 
end

def build_rows(row_len, base_integer)
  row = []
  loop do
    row << base_integer += 2
    break if row_len == row.length
  end
  row
end

sum_input_row(4)
