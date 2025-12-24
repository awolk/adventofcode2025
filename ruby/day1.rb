require_relative './lib/aoc'
require_relative './lib/grid'
require_relative './lib/parser'

def count_zeros(rotations)
  ends_up_at_zero = 0
  hits_zero = 0
  pos = 50
  rotations.each do |direction, amount|
    # numbers are small enough to just brute force it
    amount.times do
      pos += direction
      pos %= 100
      hits_zero += 1 if pos == 0
    end

    ends_up_at_zero += 1 if pos == 0
  end

  [ends_up_at_zero, hits_zero]
end

input = AOC.get_input(1)
parser = (P.any([P.str('L').map {-1}, P.str('R').map {1}]) & P.int).each_line
rotations = parser.parse_all(input)

pt1, pt2 = count_zeros(rotations)
puts "Part 1: #{pt1}"
puts "Part 2: #{pt2}"
