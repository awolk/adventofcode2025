require_relative './lib/aoc'
require_relative './lib/grid'
require_relative './lib/parser'

def accessible_positions(grid)
  grid.all_indexes('@').filter do |pos|
    grid.neighbors(pos).count('@') < 4
  end
end

input = AOC.get_input(4)
grid = Grid.chars(input)

last_accessible = accessible_positions(grid)
pt1 = last_accessible.length
puts "Part 1: #{pt1}"

removable = 0
while !last_accessible.empty?
  removable += last_accessible.size
  last_accessible.each do |pos|
    grid[pos] = 'x'
  end
  last_accessible = accessible_positions(grid)
end
puts "Part 2: #{removable}"
