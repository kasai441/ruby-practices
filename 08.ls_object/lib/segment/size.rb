# frozen_string_literal: true

require_relative 'segment'

class Segment::Size
  include Segment

  attr_accessor :value, :space

  def display
    SPACE_STRING * @space + @value
  end

  BLANK_NUM = 2
  def need_space(max_size)
    max_size - @value.size + BLANK_NUM
  end

  def choose(stat)
    @value = stat.size.to_s
  end
end
