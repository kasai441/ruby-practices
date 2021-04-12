# frozen_string_literal: true

require_relative 'details_unit'

class Segment::Timestamp < Segment::DetailsUnit
  def need_space(_)
    0
  end

  def choose(stat)
    @name = stat.mtime.strftime('%b %d %H:%M')
  end
end
