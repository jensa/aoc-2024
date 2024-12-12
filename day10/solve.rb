file = File.open("test_input.txt")
file_data = file.readlines.map(&:chomp)

matrix = []
trail_heads = []
file_data.each_with_index do |line, y|
  matrix[y] = []
  line.split("").each_with_index do |col, x|
    matrix[y] << col.to_i
    if col == '0'
      trail_heads << [y,x]
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

def p_m(matrix) 
  matrix.each do |l|
    puts(l.inspect)
  end
end
p_m(matrix)
puts(trail_heads.inspect)


def valid_direction_points(matrix, cur_pos)
  y,x = cur_pos
  return [[y - 1, x], [y, x + 1], [y + 1, x], [y, x - 1]].filter{|p| !outside_of_matrix(p, matrix)}
end

def bfs(matrix, at_point, for_value, visited)
  if for_value == 9
    score = visited["#{at_point[0]},#{at_point[1]}"] ? 1 : 1
    visited["#{at_point[0]},#{at_point[1]}"] = true
    return score
  end

  visited["#{at_point[0]},#{at_point[1]}"] = true
  # get all from 4 positions that have for_value +1
  # bfs those and return their sums
  #base case is for_value is 9, return 1
  return valid_direction_points(matrix, at_point).filter{|p| matrix[p[0]][p[1]] == for_value + 1 }.map{|p| bfs(matrix, p, for_value +1, visited)}.sum
end

sum = 0
trail_heads.each do |trail_head|
  sum += bfs(matrix, trail_head, 0, {})
end

puts("total sum: " + sum.to_s)