require_relative './lib/aoc'
require_relative './lib/parser'
require 'matrix'


parser = P.int.delimited(',').map(&Vector.method(:elements)).each_line
input = AOC.get_input(8)
vectors = parser.parse_all(input)

pt1 = nil
pt2 = nil

group_id = {} # map from vector to its group
next_group = 0

vectors.combination(2).sort_by do |a, b|
  (a - b).magnitude
end.each_with_index do |(a, b), i|
  existing_groups = [group_id[a], group_id[b]].compact
  case existing_groups
  in []
    group_id[a] = next_group
    group_id[b] = next_group
    next_group += 1
  in [g1]
    # one was already connected
    group_id[a] = g1
    group_id[b] = g1
  in [g1, g2]
    # both are connected, convert g2 into c1
    currently_g2 = group_id.select {|_, group| group == g2}.keys
    currently_g2.each {|v| group_id[v] = g1}
  end

  counts = group_id.values.tally.values
  if i == 999
    pt1 = counts.sort.last(3).reduce(:*)
  end
  if counts.size == 1 && group_id.size == vectors.size
    pt2 = a[0] * b[0]
    break
  end
end


puts "Part 1: #{pt1}"
puts "Part 2: #{pt2}"
