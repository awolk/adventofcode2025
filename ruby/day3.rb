require_relative './lib/aoc'
require_relative './lib/grid'
require_relative './lib/parser'

def max_joltage(bank, digits)
  (digits - 1).downto(0).map do |digits_left|
    eligible = bank[0, bank.length - digits_left]
    chr, ind = eligible.each_with_index.max_by(&:first)
    bank = bank[(ind + 1)..]
    chr
  end.join.to_i
end

input = AOC.get_input(3)
lines = input.split.map(&:chars)

pt1 = lines.sum {|line| max_joltage(line, 2)}
puts "Part 1: #{pt1}"

pt2 = lines.sum {|line| max_joltage(line, 12)}
puts "Part 2: #{pt2}"
