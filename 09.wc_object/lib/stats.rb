# frozen_string_literal: true

class Stats
  def initialize(text, params)
    @text = text
    @params = params
  end

  def val(key)
    {
      "lines": @text.count("\n"),
      "words": @text.strip.split(/[\s　]+/).count,
      "bytes": @text.bytesize
    }[key]
  end

  def display
    vals.map { |v| v.to_s.rjust(8) }.join
  end

  def vals
    @params.keys.map { |key| val(key) if @params[key] }.compact
  end
end
