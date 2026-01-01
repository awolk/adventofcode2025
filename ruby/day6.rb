require_relative './lib/aoc'
require_relative './lib/grid'

input = AOC.get_input(6)

lines = input.split("\n")
op_line = lines[-1]
op_chunks = op_line.chars.chunk_while {_2 == ' '}.map(&:join).to_a
int_grid = Grid.new(lines[...-1].map(&:chars))

def grid_ints(section) = section.row_strings.map(&:strip).reject(&:empty?).map(&:to_i)

pt1 = 0
pt2 = 0
col = 0
op_chunks.each do |op_chunk|
  col_range = (col ... (col + op_chunk.size))
  col += op_chunk.size
  
  op = op_chunk[0].to_sym
  section = int_grid.subsection(0.., col_range)
  pt1 += grid_ints(section).inject(op)
  pt2 += grid_ints(section.transpose).inject(op)
end

puts "Part 1: #{pt1}"
puts "Part 2: #{pt2}"
