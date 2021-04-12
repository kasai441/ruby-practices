# frozen_string_literal: true

require 'etc'

require_relative 'details_unit'

class Segment::Group < Segment::DetailsUnit
  MINIMUM = 7
  def need_space(max_size)
    max_size = MINIMUM if max_size < MINIMUM
    max_size - @name.size
  end

  def choose(stat)
    @name = get_group_name(stat.gid)
  end

  def get_group_name(gid)
    Etc.getgrgid(gid).name
  rescue ArgumentError
    'error'
  end
end
