# frozen_string_literal: true

class WcStat
  def initialize(text, lines: false, words: false, bytes: false)
    @text = text
    @params = {
      lines: lines,
      words: words,
      bytes: bytes
    }.select { |_, v| v }
  end

  def display
    values.map { |v| v.to_s.rjust(8) }.join
  end

  def values
    @params.keys.map { |key| value_of(key) }
  end

  private

  def value_of(key)
    return 0 if @text.nil?

    case key
    when :lines
      @text.count("\n")
    when :words
      @text.strip.split(/[\s　]+/).count
    when :bytes
      @text.bytesize
    end
  end
end
