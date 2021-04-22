# frozen_string_literal: true

require_relative 'stats'
require_relative 'path_stats'
require_relative 'total_stats'

class WordCount
  def initialize(input_paths, input_text, params)
    @input_paths = input_paths
    @input_text = input_text
    @params = params
    @paths = nil
  end

  def display
    if @input_paths
      @paths = Dir.glob(@input_paths).sort
      if @paths.size.zero?
        "wc: #{@input_paths[0]}: open: No such file or directory"
      elsif @paths.size == 1
        PathStats.new(@paths.first, **@params).display
      else
        total_stats = TotalStats.new(**@params)
        @paths.map do |path|
          stats = PathStats.new(path, **@params)
          total_stats.add(stats.values)
          stats.display
        end.push(total_stats.display).join("\n")
      end
    else
      Stats.new(@input_text, **@params).display
    end
  end
end
