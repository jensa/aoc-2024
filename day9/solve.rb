file = File.open("test_input.txt")
file_data = file.readlines.map(&:chomp)
file_blocks = []
hole_indices = {}
file_data[0].split("").each_with_index do |char,i|
  if i % 2 == 0
    file_id = i/2
    char.to_i.times do 
      file_blocks << file_id.to_i
    end
  else
    if char.to_i > 0
      if hole_indices[char.to_i].nil?
        hole_indices[char.to_i] = []
      end
      hole_indices[char.to_i] << file_blocks.length
    end
    char.to_i.times do 
      file_blocks << "."
    end
    
  end
end

def get_file_id_to_size(blockz)
  file_id_to_size = Hash.new(0)
  blockz.each do |b|
    file_id_to_size[b] += 1
  end
end


starting_blocks = get_file_id_to_size(file_blocks)

#puts("file blocks is")
puts(file_blocks.inspect)
#puts("holes is")
#puts(hole_indices.inspect)
#puts(hole_indices.inspect)

def chksum(blocks)
  checksum = 0
  blocks.each_with_index do |bl, i|
    if bl != '.'
      checksum += (bl*i)
    end
  end
  return checksum
end

back_i = file_blocks.length - 1
front_i = 0

moved_file_ids= {}
while back_i >= 0
  if file_blocks[back_i] == '.'
    back_i-=1
  elsif moved_file_ids[file_blocks[back_i]]
    back_i -= 1
  else
    file_id_to_move = file_blocks[back_i]
    #puts("moving #{file_id_to_move}")
    moved_file_ids[file_id_to_move] = true
    file_size = 0
    cur_char = file_blocks[back_i]
    while cur_char == file_id_to_move
      file_size += 1
      back_i-=1
      cur_char = file_blocks[back_i]
    end
    #we have a file size
    # get the first block of that size if exists

    # get the leftmost block of each size that is bigger or equal to the file_size and is left to back_i
    candidates = []
    test_size = 9
    while test_size >= file_size
      if !hole_indices[test_size].nil? && !hole_indices[test_size].find{|ind| ind < back_i}.nil?
        candidates << [hole_indices[test_size].find{|ind| ind < back_i}, test_size]
      end
      test_size -=1
    end
    #puts("candidates are:")
    #puts(candidates.inspect)
    first_hole_of_size_to_the_left_arr = candidates.filter{|c| !c.nil? && !c[0].nil?}.length < 1 ? nil : candidates.filter{|c| !c.nil? && !c[0].nil?}.sort_by {|obj| obj[0]}[0]
    first_hole_of_size_to_the_left = first_hole_of_size_to_the_left_arr.nil? ? nil : first_hole_of_size_to_the_left_arr[0]
    #puts("the candidates are #{candidates}")
    #puts("I found a hole of size #{file_size} to the left of #{back_i} for file_id #{file_id_to_move}")
    #puts("its actually at index #{first_hole_of_size_to_the_left}")
    if !first_hole_of_size_to_the_left.nil?
      hole_ind = first_hole_of_size_to_the_left
      file_ind = back_i +1
      file_size.times do 
        file_blocks[hole_ind] = file_id_to_move
        hole_ind+=1
        file_blocks[file_ind] = '.'
        file_ind +=1
      end
      # remove the hole lol
      size_to_remove_hole_in = first_hole_of_size_to_the_left_arr[1]
      hole_indices[size_to_remove_hole_in] = hole_indices[size_to_remove_hole_in].filter{|e| e != first_hole_of_size_to_the_left}
      #add in a new hole if the hole is bigger than the size
      if size_to_remove_hole_in > file_size
        new_hole_index = first_hole_of_size_to_the_left + file_size
        new_hole_size = size_to_remove_hole_in - file_size
        if hole_indices[new_hole_size].nil?
          hole_indices[new_hole_size] = []
        end
        insert_at_index = 0

        hole_indices[new_hole_size].each_with_index do |hole_index, i|
          if hole_index > new_hole_index
            insert_at_index = i
            break
          end
        end
        hole_indices[new_hole_size].insert(insert_at_index,new_hole_index)
      end
      #puts("and now blocks is")
      #puts(file_blocks.inspect)

      #puts("and now holes is")
      #puts(hole_indices.inspect)
      puts(file_blocks.inspect)

    else
      #puts("not moving filezzz id #{file_id_to_move} with size #{file_size} at #{back_i}")
      #puts("because holes at that size are ")
      #puts(hole_indices[file_size].inspect)
      #puts("and candidates are just")
      #puts(candidates.inspect)
      back_i-=1;
    end
  end
end

#puts(file_blocks.inspect)
puts("part two:")
puts(chksum(file_blocks))
puts("did we move 5433?")
puts(moved_file_ids[5433])

end_blocks = get_file_id_to_size(file_blocks)
puts("are they equal? lol")
puts (end_blocks == starting_blocks)




