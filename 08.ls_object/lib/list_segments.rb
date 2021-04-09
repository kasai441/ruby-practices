# frozen_string_literal: true

require 'pathname'
require 'etc'

require_relative './row/names'

class ListSegments
  attr_reader :rows

  def initialize(path, params)
    @path = path || '.'
    @params = params
    items = Dir.exist?(@path) ? Dir.foreach(@path).to_a : [@path]
    @items = apply_order_option(items, @params[:a], @params[:r])
    @rows = [Row::Names.new(@items)]
  end

  def apply_order_option(items, a_opt, r_opt)
    items.sort!
    items.delete_if { |f| f.match?(/^\..*/) } unless a_opt
    r_opt ? items.reverse! : items
  end

  def display
    if @params[:l]
      details
    else
      divide_rows
      @rows.map(&:display).join("\n") unless @items.size.zero?
    end
  end

  def divide_rows
    return if @rows.first.size_total <= display_size.to_i

    max_size = @rows.first.max_size
    columns_num = display_size.to_i / max_size
    rows_num = (@items.size / columns_num.to_f).ceil
    rows_num.times do |r|
      m = @items.map.with_index { |v, i| i % rows_num == r ? v : nil }
      @rows[r] = Row::Names.new(m.compact, max_size)
    end
  end

  def details
    data = []
    blocks = 0
    # binding.irb
    @items.each do |f|
      pathname = Pathname(@path).join(f)
      stat = get_stat(pathname)
      data << get_data(stat, f, pathname)
      blocks += stat.blocks
    end
    data = to_same_width(data)
    puts "total #{blocks}"
    data.map { |d| d.join(' ') }
  end

  def get_stat(pathname)
    # File.statにシンボリックリンクのパスを入れると例外となる
    # その場合File.lstatにパスを入れる
    # File.lstatで例外となる場合異常終了とする
    File.stat(pathname)
  rescue SystemCallError
    File.lstat(pathname)
  end

  def get_data(stat, file, pathname)
    datum = []
    datum << to_char_ftype(stat.ftype) + to_char_mode(stat.mode)
    datum << stat.nlink
    datum << Etc.getpwuid(stat.uid).name
    datum << get_group_name(stat.gid)
    datum << stat.size
    datum << stat.mtime.strftime('%b %d %H:%M')
    datum << (datum[0][0] == 'l' ? "#{file} -> #{File.readlink(pathname)}" : file)
    datum
  end

  def to_char_ftype(ftype)
    {
      "file": '-',
      "directory": 'd',
      "characterSpecial": 'c',
      "blockSpecial": 'b',
      "fifo": 'p',
      "link": 'l',
      "socket": 's',
      "unknown": '?'
    }[ftype.to_sym]
  end

  def to_char_mode(mode)
    mode = format('0%o', mode)[-3, 3]
    mode.split('').map { |m| which_mode(m) }.join
  end

  def which_mode(mode)
    {
      "0": '---',
      "1": '--x',
      "2": '-w-',
      "3": '-wx',
      "4": 'r--',
      "5": 'r-x',
      "6": 'rw-',
      "7": 'rwx'
    }[mode.to_sym]
  end

  def get_group_name(gid)
    Etc.getgrgid(gid).name
  rescue ArgumentError
    'error'
  end

  def to_same_width(data)
    data
  end

  def display_size
    `tput cols`.gsub(/\D/, '')
  end
end
