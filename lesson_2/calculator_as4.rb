require 'yaml'
MESSAGE = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(input)
  input.to_f.to_s == input || input.to_i.to_s == input
end

def operation_to_message(op)
  word = case op
         when '1'
           'Adding'
         when '2'
           'Subtracting'
         when '3'
           'Multiplying'
         when '4'
           'Dividing'
         end
  word
end

prompt MESSAGE["welcome"]

name = ''
loop do
  name = gets.chomp
  if name.empty?
    prompt MESSAGE['valid_name']
  else
    break
  end
end

prompt "Hi, #{name}!"

loop do # main loop
  num1 = ''
  loop do
    prompt MESSAGE['first_num']
    num1 = gets.chomp
    if valid_number?(num1)
      break
    else
      prompt MESSAGE['invalid_num']
    end
  end

  num2 = ''
  loop do
    prompt MESSAGE['second_num']
    num2 = gets.chomp
    if valid_number?(num2)
      break
    else
      prompt MESSAGE['invalid_num']
    end
  end

  prompt MESSAGE['operator_prompt']
  operator = ''
  loop do
    operator = gets.chomp
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt MESSAGE['invalid_operator']
    end
  end

  prompt "#{operation_to_message(operator)} your numbers..."

  result = case operator
           when '1'
             num1.to_i + num2.to_i
           when '2'
             num1.to_i - num2.to_i
           when '3'
             num1.to_i * num2.to_i
           when '4'
             num1.to_f / num2.to_f
           end

  prompt "The result is #{result}"

  prompt MESSAGE['again?']
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt MESSAGE['exit']
