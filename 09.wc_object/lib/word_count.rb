# frozen_string_literal: true

require_relative 'wc_stat'
require_relative 'path_stat'
require_relative 'total_stat'

class WordCount
  def initialize(input_paths, input_text, lines: false, words: false, bytes: false)
    @input_paths = input_paths
    @input_text = input_text
    @lines = lines
    @words = words
    @bytes = bytes
    @paths = nil
  end

  def display
    if @input_paths
      @paths = Dir.glob(@input_paths).sort
      if @paths.size.zero?
        "wc: #{@input_paths[0]}: open: No such file or directory"
      elsif @paths.size == 1
        PathStat.new(@paths.first, lines: @lines, words: @words, bytes: @bytes).display
      else
        total_stat = TotalStat.new(lines: @lines, words: @words, bytes: @bytes)
        @paths.map do |path|
          stat = PathStat.new(path, lines: @lines, words: @words, bytes: @bytes)
          total_stat.add(stat)
          stat.display
        end.push(total_stat.display).join("\n")
      end
    else
      WcStat.new(@input_text, lines: @lines, words: @words, bytes: @bytes).display
    end
  end
end
