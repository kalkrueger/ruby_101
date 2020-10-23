def joinor(arr, sym1 = ', ', sym2 = 'or')
  if arr.size < 3
    arr.join(" " + sym2 + " ")
  else
    arr[0..-2].join(sym1) + "#{sym1}#{sym2} #{arr[-1]}"
  end
end

a = [1, 2, 3, 4, 5]

puts joinor(a, ', ', 'or')
