# frozen_string_literal: true

require_relative 'segment'

class Segment::Timestamp
  include Segment

  attr_accessor :value, :space

  def need_space(_)
    0
  end

  def display
    SPACE_STRING + @value
  end

  def choose(stat)
    @value = stat.mtime.strftime('%_m %_d %H:%M')
  end
end
