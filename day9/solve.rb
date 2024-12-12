file = File.open("input.txt")
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
puts(file_blocks.map{|b| b.to_s}.inspect)
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
  if file_blocks[back_i] == '.' || moved_file_ids[file_blocks[back_i]]
    back_i-=1
  else
    size = 0
    file_id = file_blocks[back_i]
    moved_file_ids[file_id] = true
    while file_blocks[back_i - size] == file_id
      size += 1
    end
    index = -1
    file_blocks.length.times do |i|
      size_at_point = 0
      fits = false
      while i + size_at_point < back_i && file_blocks[i + size_at_point] == '.'
        size_at_point += 1
        if size_at_point >= size
          fits = true
          break
        end
      end
      if fits
        index = i
        break
      end
    end
    if index > 0
      #put the file at index
      # then clear the space where the file was before
      size.times do |s|
        file_blocks[back_i - s] = '.'
        file_blocks[index + s] = file_id
      end
    end
    #puts(file_blocks.map{|b| b.to_s}.inspect)
    back_i -= size
  end
end

#puts(file_blocks.inspect)
puts("part two:")
puts(chksum(file_blocks))




