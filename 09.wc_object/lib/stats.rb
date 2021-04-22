# frozen_string_literal: true

class Stats
  def initialize(text, params)
    @text = text
    @params = params # falseのものを除外する
  end

  def val(key) # ここの実装にWCの指定がリンクするように
    {
      lines: @text.count("\n"),
      words: @text.strip.split(/[\s　]+/).count,
      bytes: @text.bytesize
    }[key]
  end

  def display
    vals.map { |v| v.to_s.rjust(8) }.join
  end

  def vals
    @params.keys.select { |k| @params[k] }.map { |key| val(key)}
  end
end
