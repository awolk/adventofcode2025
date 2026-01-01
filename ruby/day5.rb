require_relative './lib/aoc'
require_relative './lib/parser'

input = AOC.get_input(5)
range_parser = P.seq(P.int, "-", P.int).map {_1 .. _2}
parser = P.seq(range_parser.each_line, "\n\n", P.int.each_line)
ranges, ingredients = parser.parse_all(input)

pt1 = ingredients.count do |i|
  ranges.any? {|r| r.include?(i)}
end
puts "Part 1: #{pt1}"

# merge overlapping ranges
ranges.sort_by!(&:first)
nonoverlapping = []
active_range = ranges[0]
ranges[1..].each do |range|
  if active_range.include?(range.first)
    active_range = active_range.first .. [range.last, active_range.last].max
  else
    nonoverlapping << active_range
    active_range = range
  end
end
nonoverlapping << active_range

pt2 = nonoverlapping.sum(&:size)
puts "Part 2: #{pt2}"
