# frozen_string_literal: true

require 'etc'

require_relative 'segment'

class Segment::Group
  include Segment

  attr_accessor :value, :space

  MINIMUM = 7
  def need_space(max_size)
    max_size = MINIMUM if max_size < MINIMUM
    max_size - @value.size
  end

  def display
    SPACE_STRING * @space + @value
  end

  def choose(stat)
    @value = get_group_name(stat.gid)
  end

  def get_group_name(gid)
    Etc.getgrgid(gid).name
  rescue ArgumentError
    'error'
  end
end
