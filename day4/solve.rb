file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
puzzle_matrix = []
file_data.each_with_index do |line, i|
  puzzle_matrix << []
  line.split("").each do |c|
    puzzle_matrix[i] << c
  end
end

def g(a,i)
  if i < 0 
    return nil 
  end
  return a[i]
end

## abandon this approach, fuck it.
# check instead each square if it has any xmases
# since there are no repeating letters, this should be fine
def has_xmas_horizontal(array, at, direction)
  return g(array,at) == "X" && g(array,at + direction) == "M" && g(array,at + (direction*2)) == "A" && g(array,at + (direction*3)) == "S"
end

def has_xmas_vertical(matrix, x, y, direction)
  #go direction in y to check next
  if g(matrix,y + direction).nil? or g(matrix,y + (direction*2)).nil? or g(matrix,y + (direction*3)).nil?
    return false
  end
  return g(g(matrix,y), x) == "X" && g(g(matrix,y + direction),x) == "M" && g(g(matrix,y+ (direction*2)), x) == "A" && g(g(matrix,y+(direction*3)),x) == "S"
end

def has_xmas_diag(matrix, x, y, direction_x, direction_y)
  #go direction in y to check next
  # we might not even have an array at a specific y, so we gotta check em
  if g(matrix,y + direction_y).nil? or g(matrix,y + (direction_y*2)).nil? or g(matrix,y + (direction_y*3)).nil?
    return false
  end
  return g(g(matrix,y),x) == "X" && g(g(matrix,y + direction_y),x + direction_x) == "M" && g(g(matrix,y + (direction_y*2)),x + (direction_x*2)) == "A" && g(g(matrix,y + (direction_y*3)), x + (direction_x*3)) == "S"
end

def test_diag(matrix, x, y)
  if matrix[y-1][x-1] == "S"
    if matrix[y+1][x+1] == "M"
      return true
    end
  end
  if matrix[y-1][x-1] == "M"
    if matrix[y+1][x+1] == "S"
      return true
    end
  end
  return false
end

def test_diag_2(matrix, x, y)
  if matrix[y-1][x+1] == "S"
    if matrix[y+1][x-1] == "M"
      return true
    end
  end
  if matrix[y-1][x+1] == "M"
    if matrix[y+1][x-1] == "S"
      return true
    end
  end
  return false
end

def has_crossmas(matrix,x,y)
  if x < 1 or y < 1 or x > matrix[0].length - 2 or y > matrix.length - 2
    return false
  end
  if matrix[y][x] != "A"
    return false
  end

  if test_diag(matrix, x, y) and test_diag_2(matrix, x, y)
    return true
  end
  return false
end

xmases = 0
crossmases = 0
puzzle_matrix.length.times do |y|

  puzzle_matrix[y].length.times do |x|
    #check crossmas
    if has_crossmas(puzzle_matrix, x,y)
      crossmases +=1
    end
    #check xmas in every direction

    if has_xmas_horizontal(puzzle_matrix[y], x, 1)
      puts("horisontal forward at #{x},#{y}")
      xmases+=1
    end
    if has_xmas_horizontal(puzzle_matrix[y], x, -1)
      puts("horisontal backward at #{x},#{y}")
      xmases+=1
    end
    if has_xmas_vertical(puzzle_matrix, x, y, 1)
      puts("vertical down at #{x},#{y}")
      xmases +=1
    end
    if has_xmas_vertical(puzzle_matrix, x, y, -1)
      puts("vertical up at #{x},#{y}")
      xmases +=1
    end

    if has_xmas_diag(puzzle_matrix, x, y, 1,1)
      puts("diag 1,1 at #{x},#{y}")
      xmases +=1
    end
    if has_xmas_diag(puzzle_matrix, x, y, 1,-1)
      puts("diag 1,-1 at #{x},#{y}")
      xmases +=1
    end
    if has_xmas_diag(puzzle_matrix, x, y, -1,1)
      puts("diag -1,1 at #{x},#{y}")
      xmases +=1
    end
    #this one freaks out for some reason...
    if has_xmas_diag(puzzle_matrix, x, y, -1, -1)
      puts("diag -1,-1 at #{x},#{y}")
      xmases +=1
    end
    #check vertical
  end
end
puts(xmases)
puts(crossmases)