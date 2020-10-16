arr = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]


a = arr.map do |hsh|
  arr2 = {}
  hsh.each do |k, v|
    arr2[k] = v + 1
  end
  arr2
end


p a
