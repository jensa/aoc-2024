def is_safe(report)
  increasing = report[0] < report[1] 
  decreasing = report[1] < report[0]
  unless increasing or decreasing
    return false
  end
  for i in 0..report.count-2 do
    if increasing
      unless report[i] < report[i+1] and report[i + 1] - report[i] < 4
        #puts("nahh this is broken, at index " + i.to_s)
        #puts(report[i])
        #puts(report[i+1])
        #puts("------")
        #puts(report)
        #puts("-----")
        return false
      end
    else
      unless report[i] > report[i+1] and report[i] - report[i+1] < 4
        return false
      end
    end
  end
  return true
end

def test_safety_with_removal(report)
  #plan: test to just remove each element ad run it again...
  # 
  for i in 0..report.count-1 do
    with_removed = report.dup
    with_removed.delete_at(i)
    if is_safe(with_removed)
      return true
    end
  end
  return false
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

reports = []
right_occurrences = Hash.new(0)
file_data.each do |line| 
  splitted = line.split.map{|r| r.to_i}
  reports << splitted 
end

safe_reports = 0;
is_part_two = false
reports.each do |report|
  if is_safe(report)
    safe_reports += 1
  elsif is_part_two and test_safety_with_removal(report)
      safe_reports += 1
  end
  
end
puts("part one:")
puts("safe reports: " + safe_reports.to_s)


