require_relative './lib/aoc'
require_relative './lib/grid'
require_relative './lib/parser'

input = AOC.get_input(2)
parser = P.seq(P.int, '-', P.int).map {_1 .. _2}.delimited(',')
ranges = parser.parse_all(input)

pt1 = 0
pt2 = 0

ranges.each do |range|
  range.each do |num|
    num_s = num.to_s.chars
    len = num_s.length
    (len / 2).downto(1).each_with_index do |substr_len, attempt|
      next if len % substr_len != 0
      chunks = num_s.each_slice(substr_len)
      if chunks.all?(chunks.first) # we found a repetition
        pt2 += num
        pt1 += num if attempt == 0 # only valid for part one if we cut in half
        break
      end
    end
  end
end

puts "Part 1: #{pt1}"
puts "Part 2: #{pt2}"
