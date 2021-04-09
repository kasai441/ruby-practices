# frozen_string_literal: true

require_relative '../segment/segment'

module Row
  include Segment

  def display
    @units.last.reset_space
    @units.map(&:display).join
  end

  def set_space
    @units.each do |unit|
      unit.space = unit.need_space(max_size)
    end
  end

  def max_size
    @max || max_space * SPACE_SIZE
  end

  def max_space
    max_unit.nil? ? 0 : max_unit.name.size
  end

  def max_unit
    @units.max_by { |v| v.name.size }
  end
end
