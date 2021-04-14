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
require_relative '../segment/blocks'

class Row::Details
  include Row

  attr_accessor :units

  def initialize(segments, dir_path = nil, stats = nil)
    @segments = segments
    @max = nil
    @units = nil

    @blocks = fetch_stats(segments, dir_path, :blocks).sum
    @stats = stats.map do |stat|
      fetch_stats(segments, dir_path, stat)
    end
  end

  def fetch_stats(segments, dir_path, stat)
    @units = segments.map do |segment|
      which_stat(stat).new(segment, dir_path)
    end
    set_space
    @units.map(&:display)
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
      "name": Segment::DetailsUnit,
      "blocks": Segment::Blocks
    }[stat]
  end

  def display
    @segments.map.with_index do |_, i|
      @stats.map { |stat| stat[i] }.join
    end.insert(0, "total #{@blocks}").join("\n")
  end
end
