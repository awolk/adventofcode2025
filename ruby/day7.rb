require_relative './lib/aoc'

input = AOC.get_input(7)
rows = input.split

splits = 0
start_col = rows[0].index('S')

# For each position, keep track of the number of ways to get there
paths = {start_col => 1}
rows[1..].each do |row|
  newpaths = Hash.new(0)
  paths.each do |col, count|
    if row[col] == '^'
      newpaths[col - 1] += count
      newpaths[col + 1] += count
      splits += 1
    else
      newpaths[col] += count
    end
  end
  paths = newpaths
end
total_paths = paths.values.sum

puts "Part 1: #{splits}"
puts "Part 2: #{total_paths}"