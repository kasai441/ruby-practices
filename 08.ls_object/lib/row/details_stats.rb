# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/type'
require_relative '../segment/size'
require_relative '../segment/details_unit'

class Row::DetailsStats
  include Row

  attr_accessor :units

  def initialize(segments, dir_path, stat)
    @dir_path = dir_path
    @units = segments.map do |segment|
      which_stat(stat).new(segment, @dir_path)
    end
    @max = nil
    set_space
  end

  def which_stat(stat)
    {
      "type": Segment::Type,
      "size": Segment::Size,
      "name": Segment::DetailsUnit
    }[stat]
  end

  def display
    @units.map(&:display)
  end

  # Block.new(stat.blocks),
  # Mode.new(to_char_mode(stat.mode)),
  # Nlink.new(stat.nlink),
  # User.new(Etc.getpwuid(stat.uid).name),
  # Group.new(get_group_name(stat.gid)),
  # Size.new(stat.size),
  # Timestamp.new(stat.mtime.strftime('%b %d %H:%M')),

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

  def get_group_name(gid)
    Etc.getgrgid(gid).name
  rescue ArgumentError
    'error'
  end

  # def display
  #   @units.last.reset_tab
  #   @units.map(&:display).join
  # end
  #
  # def max_size
  #   @max || max_tab * Unit.tab_size
  # end
  #
  # def max_tab
  #   return 0 if max_unit.nil?
  #
  #   just_multiple = (max_unit.name.size % Unit.tab_size).zero? ? 1 : 0
  #   (max_unit.name.size / Unit.tab_size.to_f).ceil + just_multiple
  # end
  #
  # def max_unit
  #   @units.max_by { |v| v.name.size }
  # end
  #
  # def set_tab
  #   @units.each do |unit|
  #     unit.tab = unit.need_tab(max_size)
  #   end
  # end
  #
  # def add_unit(name)
  #   @units << Unit.new(name)
  #   set_tab
  # end
  #
  # def size_total
  #   # 最後のタブも含めて計算
  #   max_size * @units.size
  # end
end
