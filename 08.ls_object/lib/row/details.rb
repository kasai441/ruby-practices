# frozen_string_literal: true

require_relative 'row'
require_relative 'details_stats'

class Row::Details
  include Row

  attr_accessor :units

  def initialize(segments, max = nil, dir_path = nil, stats = nil)
    @segments = segments
    @max = max
    @blocks = Row::DetailsStats.new(segments, dir_path, :blocks).display.sum
    @stats = stats.map do |stat|
      Row::DetailsStats.new(segments, dir_path, stat)
    end
  end

  def display
    @segments.map.with_index do |_, i|
      @stats.map { |stat| stat.display[i] }.join
    end.insert(0, "total #{@blocks}").join("\n")
  end
end
