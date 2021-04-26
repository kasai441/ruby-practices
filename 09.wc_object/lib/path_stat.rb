# frozen_string_literal: true

class PathStat < WcStat
  def initialize(path, lines: false, words: false, bytes: false)
    @path = path
    text = File.read(@path) unless directory?
    super(text, **{ lines: lines, words: words, bytes: bytes })
  end

  def display
    if directory?
      "wc: #{@path}: read: Is a directory"
    else
      super + " #{@path}"
    end
  end

  private

  def directory?
    FileTest.directory?(@path)
  end
end
