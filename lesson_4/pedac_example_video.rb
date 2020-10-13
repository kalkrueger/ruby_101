def sum_even_number_row(row_number)
  row =[]
  start_integer = 2
  (1..row_number).each do |current_row_number|
    row << create_row(start_integer, current_row_number)
    start_integer = row.last.last + 2
  end
  row.last.sum
end

def create_row(start_integer, row_lenght)
  row = []
  current_integer = start_integer
  loop do
    row << current_integer
    current_integer += 2
    break if row.length == row_lenght
  end
  row
end

p sum_even_number_row(1) == 2
p sum_even_number_row(2) == 10
p sum_even_number_row(4) == 68


p create_row(2,1) == [2]
p create_row(4,2) == [4,6]
p create_row(8, 3) == [8, 10, 12]

p sum_even_number_row(4)
