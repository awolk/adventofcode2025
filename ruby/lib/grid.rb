require 'matrix'

class Grid
  def initialize(rows)
    @rows = rows
    @row_count = rows.length
    @column_count = rows[0].length
  end

  def self.chars(input)
    new(input.split("\n").map(&:chars))
  end

  def self.digits(input)
    new(input.split("\n").map {|line| line.chars.map(&:to_i)})
  end

  def self.with_dimensions(rows, cols, &blk)
    rows = (0...rows).map do |row|
      (0...cols).map {|col| blk.call(row, col)}
    end
    new(rows)
  end

  attr_reader :rows, :row_count, :column_count

  def [](r, c=nil)
    r, c = r if r.is_a?(Array)
    @rows[r]&.[](c)
  end

  def []=(*args)
    if args.length == 2
      (r, c), val = args
    elsif args.length == 3
      r, c, val = args
    else
      raise 'invalid arguments'
    end
    @rows[r][c] = val
  end

  def row(r)
    @rows[r]
  end
  
  def column(c)
    @rows.map {|row| row[c]}
  end

  def columns
    @rows.transpose
  end

  def valid_pos?(r, c=nil)
    r, c = r if r.is_a?(Array)
    r.between?(0, @row_count - 1) && c.between?(0, @column_count - 1)
  end

  def at_edge?(r, c=nil)
    r, c = r if r.is_a?(Array)
    r == 0 || r == @row_count - 1 || c == 0 || c == @column_count - 1
  end

  def clone
    Grid.new(@rows.map(&:clone))
  end

  def transpose
    Grid.new(@rows.transpose)
  end

  def subsection(row_range, col_range)
    Grid.new(@rows[row_range].map {|col| col[col_range]})
  end

  def each_tile(tile_rows, tile_cols, &blk)
    return to_enum(:each_tile, tile_rows, tile_cols) if blk.nil?
    (0 .. row_count - tile_rows).each do |row_index|
      (0 .. column_count - tile_cols).each do |col_index|
        row_range = row_index ... row_index + tile_rows
        col_range = col_index ... col_index + tile_cols
        blk.call(subsection(row_range, col_range))
      end
    end
  end

  def each_with_index(&blk)
    return to_enum(:each_with_index) if blk.nil?
    @rows.each_with_index do |row, row_index|
      row.each_with_index do |val, col_index|
        blk.call(val, Vec2.new(row_index, col_index))
      end
    end
  end

  def index(target)
    each_with_index do |val, pos|
      return pos if val == target
    end
    nil
  end

  def all_indexes(target)
    each_with_index.filter_map do |val, pos|
      pos if val == target
    end
  end

  def neighbor_positions(r, c=nil, diagonals: true)
    r, c = r if r.is_a?(Array)
    positions =
      if diagonals
        [r-1, r, r+1].product([c-1, c, c+1])
      else
        [[r, c-1], [r, c+1], [r-1, c], [r+1, c]]
      end.select do |pos|
        pos != [r, c] && valid_pos?(pos)
      end
    positions.map {|(r, c)| Vec2.new(r, c)}
  end

  def neighbors_with_positions(r, c=nil, diagonals: true)
    neighbor_positions(r, c, diagonals: diagonals).map do |pos|
      [self[pos], pos]
    end
  end

  def neighbors(r, c=nil, diagonals: true)
    neighbor_positions(r, c, diagonals: diagonals).map do |pos|
      self[pos]
    end
  end

  def row_strings
    @rows.map(&:join)
  end

  def display
    row_strings.each {|row| puts row}
  end

  class Vec2 < Array
    def initialize(r, c)
      super([r, c])
    end

    def r = first
    def c = last
    def x = first
    def y = last

    def +(other)
      raise "unexpected operand #{other.inspect}" unless other.is_a?(Array) && other.length == 2
      Vec2.new(r + other[0], c + other[1])
    end

    def -(other)
      raise "unexpected operand #{other.inspect}" unless other.is_a?(Array) && other.length == 2
      Vec2.new(r - other[0], c - other[1])
    end

    def *(other)
      raise "unexpected operand #{other.inspect}" unless other.is_a?(Numeric)
      Vec2.new(r * other, c * other)
    end

    def /(other)
      raise "unexpected operand #{other.inspect}" unless other.is_a?(Numeric)
      Vec2.new(r / other, c / other)
    end

    def magnitude
      Math.sqrt(r ** 2 + c ** 2)
    end

    def manhattan_dist(other=nil)
      return r.abs + c.abs if other.nil?
      (r - other[0]).abs + (c - other[1]).abs
    end

    UP = new(-1, 0)
    DOWN = new(1, 0)
    LEFT = new(0, -1)
    RIGHT = new(0, 1)
  end
end