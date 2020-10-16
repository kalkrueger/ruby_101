arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

a = arr.map do |inner|
  inner.sort.reverse
end

p a
