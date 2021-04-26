# frozen_string_literal: true

require_relative './row/names'
require_relative './row/details'

class ListSegments
  def initialize(path, params, stats)
    @path = path || '.'
    @params = params
    @segments = to_segments
    @stats = stats
  end

  def to_segments
    segments = Dir.exist?(@path) ? Dir.foreach(@path).to_a : [@path]
    ListSegments.apply_order_option(segments, @params[:a], @params[:r])
  end

  def self.apply_order_option(segments, a_opt, r_opt)
    segments.sort!
    segments.delete_if { |f| f.match?(/^\..*/) } unless a_opt
    r_opt ? segments.reverse! : segments
  end

  def display
    if @params[:l]
      Row::Details.new(@segments, @path, @stats).display
    else
      Row::Names.new(@segments).display
    end
  end
end
