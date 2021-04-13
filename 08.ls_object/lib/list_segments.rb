# frozen_string_literal: true

require 'pathname'
require 'etc'

require_relative './row/names'
require_relative './row/details'

class ListSegments
  attr_reader :rows

  def initialize(path, params, stats)
    @path = path || '.'
    @params = params
    @stats = stats
    segments = Dir.exist?(@path) ? Dir.foreach(@path).to_a : [@path]
    @segments = ListSegments.apply_order_option(segments, @params[:a], @params[:r])
    @rows = nil
  end

  def self.apply_order_option(segments, a_opt, r_opt)
    segments.sort!
    segments.delete_if { |f| f.match?(/^\..*/) } unless a_opt
    r_opt ? segments.reverse! : segments
  end

  def display
    if @params[:l]
      Row::Details.new(@segments, nil, @path, @stats).display
    else
      @rows = [Row::Names.new(@segments)]
      divide_rows
      @rows.map(&:display).join("\n") unless @segments.size.zero?
    end
  end

  def divide_rows
    return if @rows.first.size_total <= display_size.to_i

    max_size = @rows.first.max_size
    columns_num = display_size.to_i / max_size
    rows_num = (@segments.size / columns_num.to_f).ceil
    rows_num.times do |r|
      m = @segments.map.with_index { |v, i| i % rows_num == r ? v : nil }
      @rows[r] = Row::Names.new(m.compact, max_size)
    end
  end

  def display_size
    `tput cols`.gsub(/\D/, '')
  end
end
