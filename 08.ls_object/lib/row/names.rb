# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/name'

class Row::Names
  include Row

  attr_accessor :units

  def initialize(items, max = nil)
    @units = items.map { |item| Segment::Name.new(item) }
    @max = max
    set_tab
  end

  def max_size
    @max || max_tab * Segment::Name.tab_size
  end

  def max_tab
    return 0 if max_unit.nil?

    just_multiple = (max_unit.name.size % Segment::Name.tab_size).zero? ? 1 : 0
    (max_unit.name.size / Segment::Name.tab_size.to_f).ceil + just_multiple
  end

  def max_unit
    @units.max_by { |v| v.name.size }
  end

  def set_tab
    @units.each do |unit|
      unit.tab = unit.need_tab(max_size)
    end
  end

  def add_unit(name)
    @units << Segment::Name.new(name)
    set_tab
  end

  def size_total
    # 最後のタブも含めて計算
    max_size * @units.size
  end
end
