arr = [[:a, 1], ['b', 'two'], ['sea', {c: 3}], [{a: 1, b: 2, c: 3, d: 4}, 'D']]

hsh = {}
a = arr.map do |sets|
  hsh[sets[0]] = sets[1]
end


p hsh
