#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def run_app
  a = false
  r = false
  l = false
  opt = OptionParser.new
  opt.on('-a') { a = true }
  opt.on('-r') { r = true }
  opt.on('-l') { l = true }
  opt.parse!(ARGV)

  path = ARGV[0]
  items = []
  Dir.foreach(path || '.') do |d|
    items << d
  end
  
  files = apply_order_option(items, a, r)
  l ? list_detail(files) : list_name(files) 
end

def apply_order_option(items, a, r)
  files = items.sort.sort { |a, b| a.gsub(/\./, '').downcase <=> b.gsub(/\./, '').downcase }
  files.delete_if { |f| f.match?(/^\..*/) } if !a
  files.reverse! if r  
  files
end
 
def list_detail(files)
  stat = File.stat("/home/kasai441/.b*")
  puts stat.dev
  puts stat.size
  puts "0%o" % stat.mode
  puts stat.mode
end

def list_name(files)
  cols = divide_to_cols(files)
  rows = cols_to_rows(cols)
  rows.each { |e| puts e.join('  ') }
end

def divide_to_cols(files)
  cols = files.map { |e| [e] }
  (2..files.size).each do |n|
    unless within_width?(cols_to_rows(cols))
      sliced = files.dup
      cols.clear
      cols_size = files.size % n == 0 ? files.size / n : files.size / n + 1
      cols_size.times { cols << sliced.slice!(0, n) }
      cols = sizeup_to_max(cols)
    end
  end
  cols
end

def cols_to_rows(cols)
  rows = []
  cols[0].size.times { |n| rows[n] = [] }

  cols.each do |col|
    col.each_with_index do |file, row_idx|
      rows[row_idx] << file
    end
  end
  rows
end

def within_width?(rows)
  width = `tput cols`.gsub(/\D/, '').to_i
  rows.each do |row|
    return false if row.join('  ').size > width
  end
  true
end

def sizeup_to_max(cols)
  result = []
  cols.map do |col|
    max = col.map { |c| c.size }.max
    result << col.map { |c| c + ' ' * (max - c.size) }
  end
  result
end

run_app
