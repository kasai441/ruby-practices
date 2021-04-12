# frozen_string_literal: true

require_relative 'details_unit'

class Segment::Mode < Segment::DetailsUnit
  def need_space(_)
    0
  end

  def choose(stat)
    @name = to_char_mode(stat.mode)
  end

  def to_char_mode(mode)
    mode = format('0%o', mode)[-3, 3]
    mode.split('').map { |m| which_mode(m) }.join
  end

  def which_mode(mode)
    {
      "0": '---',
      "1": '--x',
      "2": '-w-',
      "3": '-wx',
      "4": 'r--',
      "5": 'r-x',
      "6": 'rw-',
      "7": 'rwx'
    }[mode.to_sym]
  end
end
