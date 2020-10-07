require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def prompt(text)
  puts "=> #{text}"
end

def validate_number(num)
  num.to_i.to_s == num || num.to_f.to_s == num
end

def monthly_payment_calculator(p, j, n)
  p * (j / (1 - (1 + j)**(-n)))
end

prompt MESSAGES['welcome']

name = ''
loop do
  prompt MESSAGES['name']
  name = gets.chomp
  if name.empty?
    prompt MESSAGES['valid_name']
  else
    puts "Great! Welcome, #{name}."
    break
  end
end

loop do # Main Loop
  loan_total = ''
  loop do
    prompt MESSAGES['gather_amount']
    loan_total = gets.chomp
    if validate_number(loan_total) && loan_total.to_i > 0
      loan_total = loan_total.to_f
      break
    elsif loan_total.to_i <= 0
      prompt MESSAGES['zero_loan']
    else
      prompt MESSAGES['invalid_loan']
    end
  end

  apr = ''
  loop do
    prompt MESSAGES['gather_apr']
    raw_apr = gets.chomp
    if validate_number(raw_apr) && raw_apr.to_i > 0
      apr = (raw_apr.to_f * 0.01)
      break
    elsif raw_apr.to_i <= 0
      prompt MESSAGES['zero_apr']
    else
      prompt MESSAGES['invalid_amount']
    end
  end

  monthly_ir = (apr / 12)

  duration_months = ''
  loop do
    prompt MESSAGES['gather_duration']
    duration_years = gets.chomp
    if validate_number(duration_years) && duration_years.to_i >= 0
      duration_months = (duration_years.to_f * 12)
      break
    elsif duration_years.to_i <= 0
      prompt MESSAGES['zero_duration']
    else
      prompt MESSAGES['invalid_duration']
    end
  end

  monthly_payment =
    monthly_payment_calculator(loan_total, monthly_ir, duration_months)

  prompt MESSAGES['calulating']
  result_prompt = <<-MSG
    Your montly payment will be: $#{monthly_payment.round(2)}.
    This will last for #{duration_months.round} months.
    Your month interst rate is: #{(monthly_ir * 100).round(2)}%.
  MSG
  prompt result_prompt

  prompt MESSAGES['repeat?']
  repeat = gets.chomp.downcase
  break if repeat != 'y'
end

prompt MESSAGES['bye']
