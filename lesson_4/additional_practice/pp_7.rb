statement = "The Flintstones Rock"

flint_arr = statement.delete(' ').split('')

flint_hash = {}

flint_arr.sort.each do |letter|
  flint_hash[letter] = flint_arr.count(letter)
end

p flint_hash
