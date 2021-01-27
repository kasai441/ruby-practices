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
  l ? list_detail(path, files) : list_name(files) 
end

def apply_order_option(items, a, r)
  files = items.sort.sort { |a, b| a.gsub(/\./, '').downcase <=> b.gsub(/\./, '').downcase }
  files.delete_if { |f| f.match?(/^\..*/) } if !a
  files.reverse! if r  
  files
end
 
def list_detail(path, files)
  path = './' if !path
  path += '/' if !path.match?(/.*\/$/)
  data = []
  blocks = 0
  files.each do |f|
    datum = []
    stat = File.stat(path + f)
    datum << to_char_ftype(stat.ftype) + to_char_mode(stat.mode)
    datum << stat.uid
    datum << stat.uid
    datum << stat.size
    datum << stat.mtime
    datum << f
    datum << stat.blocks
    data << datum.join(' ')
    blocks += stat.blocks
  end
  puts "total #{blocks}"
  puts data
end

def to_char_ftype(ftype)
  {
    "file": "-",
    "directory": "d",
    "characterSpecial": "c",
    "blockSpecial": "b",
    "fifo": "p",
    "link": "l",
    "socket": "s",
    "unknown": "?"
  }[ftype.to_sym]
end

def to_char_mode(mode)
  mode = "0%o" % mode
  mode = mode[-3, 3]
  mode = mode.split('').map { |m| which_mode(m) }.join
end

def which_mode(m)
  {
    "0": "---",
    "1": "--x",
    "2": "-w-",
    "3": "-wx",
    "4": "r--",
    "5": "r-x",
    "6": "rw-",
    "7": "rwx"
  }[m.to_sym]
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
