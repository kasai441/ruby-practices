# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/name'

class Row::Names
  include Row

  attr_reader :units

  def initialize(segments, max = nil)
    @segments = segments
    @units = segments.map { |segment| Segment::Name.new(segment) }
    @max = max
    set_space
  end

  def display
    rows.map(&:display_units).join("\n") unless @segments.size.zero?
  end

  def rows
    return [self] if size_total <= display_size.to_i

    columns_num = display_size.to_i / max_size
    rows_num = (@units.size / columns_num.to_f).ceil
    Array.new(rows_num).map.with_index do |_, row_idx|
      m = @segments.map.with_index { |v, i| i % rows_num == row_idx ? v : nil }
      Row::Names.new(m.compact, max_size)
    end
  end

  def display_units
    @units.last.reset_space
    @units.map(&:display).join
  end

  def display_size
    `tput cols`.gsub(/\D/, '')
  end

  def max_size
    @max || max_space * TAB_SIZE
  end

  def max_space
    return 0 if max_unit.nil?

    just_multiple = (max_unit.value.size % TAB_SIZE).zero? ? 1 : 0
    (max_unit.value.size / TAB_SIZE.to_f).ceil + just_multiple
  end

  def add_unit(value)
    @units << Segment::Name.new(value)
    set_space
  end

  def size_total
    # 最後のタブも含めて計算
    max_size * @units.size
  end
end
