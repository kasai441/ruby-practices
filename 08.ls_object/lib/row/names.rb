# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/name'

class Row::Names
  include Row

  attr_accessor :units

  def initialize(segments, max = nil, dir_path = nil)
    @units = segments.map { |item| Segment::Name.new(item) }
    @max = max
    set_space
  end

  def max_size
    @max || max_space * TAB_SIZE
  end

  def max_space
    return 0 if max_unit.nil?

    just_multiple = (max_unit.name.size % TAB_SIZE).zero? ? 1 : 0
    (max_unit.name.size / TAB_SIZE.to_f).ceil + just_multiple
  end

  def add_unit(name)
    @units << Segment::Name.new(name)
    set_space
  end

  def size_total
    # 最後のタブも含めて計算
    max_size * @units.size
  end
end