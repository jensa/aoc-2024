file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
list_one = []
list_two = []

right_occurrences = Hash.new(0)
file_data.each do |line| 
  splitted = line.split
  first = splitted[0].to_i
  second = splitted[1].to_i
  list_one << first
  list_two << second
  right_occurrences[second] += 1

end
list_one = list_one.sort()
list_two = list_two.sort()

results = []
for i in 0..list_one.count-1 do
  results << (list_one[i] - list_two[i]).abs
end

puts("part one:")
puts(results.sum)

similarity = 0;
for i in 0..list_one.count-1 do
  similarity += right_occurrences[list_one[i]] * list_one[i]
end

puts("part two:")
puts(similarity)

