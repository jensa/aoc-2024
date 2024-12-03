file = File.open("input.txt")
muls = file.read.scan(/mul\(([0-9]+),([0-9]+)\)|(don't\(\))|(do\(\))/)
sum = 0
enabled = true
muls.each do |mul|
  if mul[2] == "don't()"
    enabled = false
  elsif mul[3] == "do()"
    enabled = true
  elsif enabled
    sum += mul[0].to_i * mul[1].to_i
  end
end
puts(sum)

