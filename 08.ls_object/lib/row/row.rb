# frozen_string_literal: true

require_relative '../segment/segment'

module Row
  include Segment

  def max_unit
    @units.max_by { |v| v.value.size }
  end

  def set_space
    @units.each do |unit|
      unit.space = unit.need_space(max_size)
    end
  end

  private

  def max_size
    @max || max_space * SPACE_SIZE
  end

  def max_space
    max_unit.nil? ? 0 : max_unit.value.size
  end
end
