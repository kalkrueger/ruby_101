arr = [[1, 6, 7], [1, 4, 9], [1, 8, 3]]

a = arr.sort_by do |sets|
  sets.select{ |n| n.odd?}
end

p a
