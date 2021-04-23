# frozen_string_literal: true

require_relative 'wc_stat'
require_relative 'path_stat'
require_relative 'total_stat'

class WordCount
  def initialize(input_paths, input_text, lines:, words:, bytes:)
    @input_paths = input_paths
    @input_text = input_text
    @params = {
      lines: lines,
      words: words,
      bytes: bytes
    }
    @paths = nil
  end

  def display
    if @input_paths
      @paths = Dir.glob(@input_paths).sort
      if @paths.size.zero?
        "wc: #{@input_paths[0]}: open: No such file or directory"
      elsif @paths.size == 1
        PathStat.new(@paths.first, @params).display
      else
        total_stat = TotalStat.new(@params)
        @paths.map do |path|
          stat = PathStat.new(path, @params)
          total_stat.add(stat.values)
          stat.display
        end.push(total_stat.display).join("\n")
      end
    else
      WcStat.new(@input_text, **@params).display
    end
  end
end
