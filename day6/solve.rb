file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
matrix = []

initial_position = []
file_data.each_with_index do |line, y|
  matrix[y] = []
  line.split("").each_with_index do |col, x|
    matrix[y] << col
    if col == "^"
      initial_position = [y,x]
    end
  end
end
size = [matrix[0].length, matrix.length]

def rotate(direction)
  case direction
  when :up then :right
  when :right then :down
  when :down then :left
  when :left then :up
  end
end

def new_pos(cur_pos, direction)
  case direction
  when :up then [cur_pos[0] - 1, cur_pos[1]]
  when :right then [cur_pos[0], cur_pos[1] + 1]
  when :down then [cur_pos[0] + 1, cur_pos[1]]
  when :left then [cur_pos[0], cur_pos[1] - 1]
  end
end

def inside(y,x)
  return y >= 0 && x >= 0
end

def step(soldier, matrix) 
  #return new soldier with pos,dir
  #soldier is a hash
  cur_pos = soldier[:pos]
  cur_dir = soldier[:direction]
  y,x = new_pos(cur_pos, cur_dir)
  #puts("#{y}, #{x}")
  if !outside_of_matrix([y,x], matrix) and matrix[y][x] == "#"
    return {:pos => cur_pos, :direction => rotate(cur_dir) }
  else
    return {:pos => [y,x], :direction => cur_dir }
  end
end

def outside_of_matrix(pos,matrix)
  mx = matrix[0].length
  my = matrix.length
  y,x = pos
  return x < 0 || y < 0 || x >= mx || y >= my
end

guard = {:pos => initial_position, :direction => :up }
visited = {} #use string coord keys
while !outside_of_matrix(guard[:pos], matrix) do
  visited[guard[:pos].to_s] = true
  guard = step(guard, matrix)
end

puts("visited len (part 1):")
puts(visited.length)

def gets_stuck_in_loop(matrix_w_obstruction, initial_position)
  visited = {} #use string coord keys
  guard = {:pos => initial_position, :direction => :up }
  while !outside_of_matrix(guard[:pos], matrix_w_obstruction) do
    key = guard[:pos].to_s + guard[:direction].to_s
    if visited[key]
      return true
    end
    visited[key] = true
    guard = step(guard, matrix_w_obstruction)
  end
  return false
end

guard = {:pos => initial_position, :direction => :up }
obstruction_counts = 0
last_changed_position = nil
matrix.length.times do |y|
  matrix[y].length.times do |x|
    puts("checking #{y},#{x} as obstruction site")
    if !last_changed_position.nil?
      matrix[last_changed_position[0]][last_changed_position[1]] = "."
      last_changed_position = nil
    end
    if y == initial_position[0] && x == initial_position[1]
      next
    end
    if matrix[y][x] == "#"
      next
    end
    matrix[y][x] = "#"
    last_changed_position = [y,x]
    if gets_stuck_in_loop(matrix, initial_position)
      obstruction_counts +=1
    end
  end
end

#plan: place an obstruction, run the loop, if we return to a previously had position/direction combo we are in a loop, if we finish we are not
# then count that obstruction
# do that for each lol



puts("obstruction_counts:")
puts(obstruction_counts)
#puts(visited.inspect)