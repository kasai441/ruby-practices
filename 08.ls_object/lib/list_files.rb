# frozen_string_literal: true

require_relative 'row'
require_relative 'unit'

class ListFiles
  attr_reader :rows

  def initialize(path, params)
    items = Dir.foreach(path || '.').to_a
    items = apply_order_option(items, params[:a], params[:r])

    @rows = [Row.new(items)]
    return if @rows.first.size_total <= display_size.to_i

    max_size = @rows.first.max_size
    columns_num = display_size.to_i / max_size
    rows_num = (items.size / columns_num.to_f).ceil
    rows_num.times do |r|
      m = items.map.with_index { |v, i| i % rows_num == r ? v : nil }
      @rows[r] = Row.new(m.compact, max_size)
    end
  end

  def apply_order_option(items, a_opt, r_opt)
    items.sort!
    items.delete_if { |f| f.match?(/^\..*/) } unless a_opt
    r_opt ? items.reverse! : items
  end

  def display
    @rows.map(&:display).join("\n") unless @rows.first.units.size.zero?
  end

  def display_size
    `tput cols`.gsub(/\D/, '')
  end
end
