# frozen_string_literal: true

class TotalStat < WcStat
  attr_reader :values

  def initialize(params)
    super(nil, **params)
    @values = Array.new(@params.keys.size, 0)
  end

  def display
    "#{super} total"
  end

  def add(input_values)
    @values.size.times do |i|
      values[i] += input_values[i]
    end
  end
end
