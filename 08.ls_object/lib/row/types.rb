# frozen_string_literal: true

require 'pathname'

require_relative 'row'
require_relative '../segment/type'

class Row::Types
  include Row

  attr_accessor :units

  def initialize(segments, max = nil, dir_path = nil)
    @dir_path = dir_path
    @units = segments.map { |segment| Segment::Type.new(get_data(segment)) }
    @max = max
    set_space
  end

  def add_unit(name)
    @units << Segment::Type.new(name)
    set_space
  end
end

def get_data(segment)
  seg_path = Pathname(@dir_path).join(segment)
  to_char_ftype(get_stat(seg_path).ftype)
end

def get_stat(path)
  # File.statにシンボリックリンクのパスを入れると例外となる
  # その場合File.lstatにパスを入れる
  # File.lstatで例外となる場合異常終了とする
  File.stat(path)
rescue SystemCallError
  p path
  File.lstat(path)
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
