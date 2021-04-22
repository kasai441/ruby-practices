# frozen_string_literal: true

require_relative 'stats'
require_relative 'path_stats'

class WordCount
  def initialize(input_paths, input_text, params)
    @input_paths = input_paths
    @input_text = input_text
    @params = params
    @paths = nil
    @total_values = nil
  end

  def display
    if @input_paths
      @paths = Dir.glob(@input_paths).sort
      if @paths.size.zero?
        "wc: #{@input_paths[0]}: open: No such file or directory"
      elsif @paths.size == 1
        PathStats.new(@paths.first, **@params).display
      else
        @paths.map do |path|
          stats = PathStats.new(path, **@params)
          add_total(stats.values)
          stats.display
        end.push(display_total).join("\n")
      end
    else
      Stats.new(@input_text, **@params).display
    end
  end

  private

  def add_total(values)
    return @total_values = values if @total_values.nil?

    @total_values.map!.with_index { |total_value, i| total_value + values[i] }
  end

  def display_total
    "#{@total_values.map { |v| v.to_s.rjust(8) }.join} total"
  end
end
