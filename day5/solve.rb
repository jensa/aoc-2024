file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
rules = {}
updates = []
getting_rules = true
file_data.each_with_index do |line, i|
  if line.include?(",")
    getting_rules = false
  end
  if getting_rules
    line_rule = line.split("|").map{|v| v.to_i}
    if rules[line_rule[0]].nil?
      rules[line_rule[0]] = []
    end
    rules[line_rule[0]] << line_rule[1]
  elsif
    updates << line.split(",").map{|v| v.to_i}
  end
end

def page_should_be_ahead(rules, page, rest)
  rest.each do |other|
    rule = rules[other]
    if rule != nil && rule.include?(page)
      return false
    end
  end
  return true
end

def sort_according_to_rules(update, rules)
  if update.length < 2
    return update
  end
  correct_index = -1
  update.length.times do |i|
    page = update[i]
    rest = update.dup.tap{|a| a.delete_at(i)}
    if page_should_be_ahead(rules, page, rest)
      correct_index = i
      break
    end
  end
  tail = update.dup.tap{|a| a.delete_at(correct_index)}
  return [update[correct_index], *sort_according_to_rules(tail, rules)]
end

correct_updates = 0
incorrect_sorted_updates = 0
updates.each do |update|
  updates_ok = true
  update.length.times do |i|
    page = update[i]

    unless page_should_be_ahead(rules, page, update.drop(i+1))
      updates_ok  = false
      break
    end
  end
  if updates_ok
    correct_updates += update[update.length/2]
  elsif
    #sort the update numbers and then get middle 
    sorted = sort_according_to_rules(update, rules)
    incorrect_sorted_updates += sorted[sorted.length/2]
  end
end
puts("correct_updates:")
puts(correct_updates)

puts("incorrect_updates (sorted):")
puts(incorrect_sorted_updates)