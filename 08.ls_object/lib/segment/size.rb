# frozen_string_literal: true

require_relative 'details_unit'

class Segment::Size < Segment::DetailsUnit
  def need_space(max_size)
    max_size - @name.size
  end

  def choose(stat)
    @name = stat.size.to_s
  end
end
