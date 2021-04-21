# frozen_string_literal: true

require_relative 'segment'

class Segment::Type
  include Segment

  attr_accessor :value, :space

  def need_space(_)
    0
  end

  private

  def choose(stat)
    @value = to_char_ftype(stat.ftype)
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
