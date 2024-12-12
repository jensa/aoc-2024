file = File.open("test_input.txt")
file_data = file.readlines.map(&:chomp)
#only one line
stones = file_data[0].split(" ").map{|h| h.to_i}

#theory: linked list would solve the "build a big fuckin array" problem - we would still store it but the modify step would not need to create a new array
#

def transform_stone(stone)
  if stone == 0
    return [1]
  elsif "#{stone}".length % 2 == 0
    str = "#{stone}"
    return [str[0, str.length/2],str[str.length/2, str.length]].map{|s| s.to_i}
  else
    return [stone * 2024]
  end
end



def stones_key(stones) 
  return stones.map{|s| s.to_s}.join(",")
end

def transform(stones, cache)
  key = stones_key(stones)
  if !cache[key].nil?
    puts("cache hit lol")
    return cache[key]
  end
  new_stones = []
  stones.each do |s|
    if s.kind_of?(Array)
      new_stones << transform(s, cache)
    else
      new_stones << transform_stone(s)
    end
  end
  cache[key] = new_stones
  return new_stones
end

cache = {}
25.times do |it|
  #puts("#{stones.length}")
  #puts(stones.inspect)
  puts("iteration #{it}")
  stones = transform(stones, cache)
end

def len_stones(stones)
  stones_len = 0
  stones.each do |s|
    if s.kind_of?(Array)
      stones_len += len_stones(s)
    else
      stones_len += 1
    end
  end
  return stones_len
end

puts(len_stones(stones))


# If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
# If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
# If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.
#puts(stones.inspect)