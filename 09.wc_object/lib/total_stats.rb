# frozen_string_literal: true

class TotalStats < Stats
  def initialize(params)
    super(nil, **params)
    @values = @params.keys.map { |key| 0 }
  end

  def display
    super + ' total'
  end

  def values
    @values
  end

  def add(values)
    @values.map!.with_index { |total, i| total + values[i] }
  end
end
