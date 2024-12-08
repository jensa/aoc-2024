file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
equations = []

matrix = []
antennas = {}
file_data.each_with_index do |line, y|
  matrix[y] = []
  line.split("").each_with_index do |col, x|
    matrix[y] << col
    if col != "."
      if antennas[col].nil?
        antennas[col] = []
      end
      antennas[col] << [y,x]
    end
  end
end
size = [matrix[0].length, matrix.length]

def outside_of_matrix(pos,matrix)
  mx = matrix[0].length
  my = matrix.length
  y,x = pos
  return x < 0 || y < 0 || x >= mx || y >= my
end


def get_antinode(a1,a2)
  path = []
  endY, endX = a2
  y,x = a1
  while y != endY || x != endX do
    step = [0,0]
    if y != endY
      step[0] = y > endY ? -1 : 1
    end
    if x != endX
      step[1] = x > endX ? -1 : 1
    end
    path << step
    y += step[0]
    x += step[1]
  end

  y,x = a2
  #puts("path between #{a1.inspect} => #{a2.inspect}:")
  #puts(path.inspect)
  #puts("-----------")
  path.each do |step|
    y += step[0]
    x += step[1]    
  end
  return [y,x]
end

def get_antinodes(a1,a2, matrix)
  path = []
  endY, endX = a2
  y,x = a1
  while y != endY || x != endX do
    step = [0,0]
    if y != endY
      step[0] = y > endY ? -1 : 1
    end
    if x != endX
      step[1] = x > endX ? -1 : 1
    end
    path << step
    y += step[0]
    x += step[1]
  end

  antinodes = []
  y,x = a2
  #puts("path between #{a1.inspect} => #{a2.inspect}:")
  #puts(path.inspect)
  #puts("-----------")
  while !outside_of_matrix([y,x], matrix) do
    antinodes << [y,x]
    path.each do |step|
      y += step[0]
      x += step[1]    
    end
  end
  return antinodes 
end

def check_pairs(antennas, matrix)
  antinodes = []
  antennas.each_with_index do |antenna, i|
    rest = antennas.reject.with_index{|v, ind| ind == i }
    rest.each do |other|
      get_antinodes(antenna, other,matrix).each do |antinode|
        antinodes << antinode
      end
    end
  end
  return antinodes.filter{|a| !outside_of_matrix(a, matrix) }
end


antinode_set = {}
antennas.each do |freq, antenna_list|
  pairs = check_pairs(antenna_list, matrix)
  puts(pairs.inspect)
  pairs.each do |antinode|
    if !antinode_set["#{antinode[0]},#{antinode[1]}"].nil?
      print("overlap antinode at ")
      puts("#{antinode[0]},#{antinode[1]}")
      antinode_set["#{antinode[0]},#{antinode[1]}"] = antinode_set["#{antinode[0]},#{antinode[1]}"] == "#" ? "2" : (antinode_set["#{antinode[0]},#{antinode[1]}"].to_i + 1).to_s
    else
      antinode_set["#{antinode[0]},#{antinode[1]}"] = "#"
    end
  end
end


matrix.length.times do |y|
  matrix[y].length.times do |x|
    if !antinode_set["#{y},#{x}"].nil?
      print(antinode_set["#{y},#{x}"])
    else
      print(matrix[y][x])
    end
  end
  puts("\n")
end

puts
puts("------------")
puts

puts(File.read("test_input.txt"))

puts("antinodes: #{antinode_set.keys.length}")