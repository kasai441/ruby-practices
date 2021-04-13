# frozen_string_literal: true

require_relative 'segment'

class Segment::Nlink
  include Segment

  attr_accessor :value, :space

  BLANK_NUM = 2
  def need_space(max_size)
    max_size - @value.size + BLANK_NUM
  end

  def display
    SPACE_STRING * @space + @value
  end

  def choose(stat)
    @value = stat.nlink.to_s
  end
end
