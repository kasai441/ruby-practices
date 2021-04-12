# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/type'
require_relative '../segment/mode'
require_relative '../segment/nlink'
require_relative '../segment/user'
require_relative '../segment/group'
require_relative '../segment/size'
require_relative '../segment/timestamp'
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
      "mode": Segment::Mode,
      "nlink": Segment::Nlink,
      "user": Segment::User,
      "group": Segment::Group,
      "size": Segment::Size,
      "timestamp": Segment::Timestamp,
      "name": Segment::DetailsUnit
    }[stat]
  end

  def display
    @units.map(&:display)
  end

  # Block.new(stat.blocks),
  # Nlink.new(stat.nlink),
  # User.new(Etc.getpwuid(stat.uid).name),
  # Group.new(get_group_name(stat.gid)),
  # Timestamp.new(stat.mtime.strftime('%b %d %H:%M')),
end
