# frozen_string_literal: true

require_relative 'row'
require_relative 'unit'

class FileList
  def initialize(path, params)
    items = Dir.foreach(path || '.').to_a
    items = apply_order_option(items, params[:a], params[:r])
    row_num = 1
    @rows = []
    row_num.times do |r|
      m = items.map.with_index { |v, i| (i % (r + 1)).zero? ? v : nil }
      @rows << Row.new(m.compact)
    end

    # return if @files.size.zero?
  end

  def apply_order_option(items, a_opt, r_opt)
    files = items.sort { |a, b| a.gsub(/^\./, '') <=> b.gsub(/^\./, '') }
    files.delete_if { |f| f.match?(/^\..*/) } unless a_opt
    files.reverse! if r_opt

    files
  end

  def display
    @rows.map(&:display).join("\n")
  end
end
