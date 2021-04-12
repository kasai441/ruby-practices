# frozen_string_literal: true

require_relative 'details_unit'

class Segment::Size < Segment::DetailsUnit
  MINIMUM = 5
  def need_space(max_size)
    max_size = MINIMUM if max_size < MINIMUM
    max_size - @name.size
  end

  def choose(stat)
    @name = stat.size.to_s
  end
end
