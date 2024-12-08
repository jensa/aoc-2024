file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
equations = []

file_data.each do |line|
  answer, inputs = line.split(":")
  equations << {:a => answer.to_i, :e => inputs.split(" ").map{|l| l.to_i}}
end

def test_eq(e,o)
  q = e[0]
  o.split("").each_with_index do |op,i|
    if op == "+"
      q += e[i+1]
    elsif op == "*"
      q *= e[i+1]
    else
      #concat op
      q = "#{q}#{e[i+1]}".to_i
    end
  end
  return q
end

def op_comb(len)
  if len <= 1
    return ["+", "*", "|"]
  end
  last_len = op_comb(len-1)
  new_ones = []
  last_len.each do |last|
    new_ones << "*#{last}"
    new_ones << "+#{last}"
    new_ones << "|#{last}"
  end
  return new_ones
end

len_to_op_combs = {}

def valid_eq(eq, combs)
  combs.each do |comb|
    if test_eq(eq[:e], comb) == eq[:a]
      return comb
    end
  end
  return nil
end


total_sum = 0
equations.each do |eq|
  test_values_len = eq[:e].length - 1
  if len_to_op_combs[test_values_len].nil?
    len_to_op_combs[test_values_len] = op_comb(test_values_len)
  end
  
  is_valid_eq = valid_eq(eq, len_to_op_combs[test_values_len])

  if !is_valid_eq.nil?
    total_sum += eq[:a]
    puts("valid combo: #{is_valid_eq} for eq")
    puts(eq.inspect)
  end

end
puts(total_sum)
