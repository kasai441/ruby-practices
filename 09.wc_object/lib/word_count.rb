# frozen_string_literal: true

require_relative 'stats'
require_relative 'stats_path'

class WordCount
  def initialize(input_paths, input_text, params)
    @input_paths = input_paths
    @input_text = input_text
    @params = params
    @paths = nil
    @vals = nil
  end

  def display
    if @input_paths
      @paths = Dir.glob(@input_paths).sort
      if @paths.size.zero?
        "wc: #{@input_paths[0]}: open: No such file or directory"
      elsif @paths.size == 1
        StatsPath.new(@paths.first, @params).display
      else
        @paths.map do |path|
          stats = StatsPath.new(path, @params)
          total(stats.vals)
          stats.display
        end.push(total_display).join("\n")
      end
    else
      Stats.new(@input_text, @params).display
    end
  end

  def total(vals)
    return @vals = vals if @vals.nil? || @vals.include?(nil)

    @vals = @vals.map { |val| val + vals.shift }
  end

  def total_display
    "#{@vals.map { |v| v.to_s.rjust(8) }.join} total"
  end
end
