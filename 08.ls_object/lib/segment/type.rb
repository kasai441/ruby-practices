# frozen_string_literal: true

require_relative 'details_unit'

class Segment::Type < Segment::DetailsUnit
  def need_space(_)
    0
  end

  def choose(stat)
    @name = to_char_ftype(stat.ftype)
  end

  def to_char_ftype(ftype)
    {
      "file": '-',
      "directory": 'd',
      "characterSpecial": 'c',
      "blockSpecial": 'b',
      "fifo": 'p',
      "link": 'l',
      "socket": 's',
      "unknown": '?'
    }[ftype.to_sym]
  end
end
