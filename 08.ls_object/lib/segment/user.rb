# frozen_string_literal: true

require 'etc'

require_relative 'details_unit'

class Segment::User < Segment::DetailsUnit
  def need_space(max_size)
    max_size - @name.size
  end

  def display
    SPACE_STRING + @name
  end

  def choose(stat)
    @name = Etc.getpwuid(stat.uid).name
  end
end
