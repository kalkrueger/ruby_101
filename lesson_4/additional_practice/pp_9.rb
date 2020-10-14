words = "the flintstones rock"

def titleize(string)
  arr = string.split(' ')
  arr.each do |word|
    string.gsub!(word, word.capitalize)
  end
  string
end

p titleize(words)
