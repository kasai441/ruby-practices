# frozen_string_literal: true

require_relative 'details_unit'

class Segment::Nlink < Segment::DetailsUnit
  MINIMUM = 3
  def need_space(max_size)
    max_size = MINIMUM if max_size < MINIMUM
    max_size - @name.size
  end

  def display
    SPACE_STRING * @space + @name
  end

  def choose(stat)
    @name = stat.nlink.to_s
  end
end
