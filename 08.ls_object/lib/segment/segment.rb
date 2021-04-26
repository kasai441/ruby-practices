# frozen_string_literal: true

require 'pathname'

module Segment
  TAB_STRING = "\t"
  TAB_SIZE = 8
  SPACE_STRING = ' '
  SPACE_SIZE = 1

  def initialize(value, dir_path = nil)
    @value = @segment = value
    @dir_path = dir_path
    @space = 0
    stats_data if dir_path
  end

  def reset_space
    @space = 0
  end

  def display
    @value + SPACE_STRING * @space
  end

  def need_space(max_size)
    max_size - @value.size
  end

  def stats_data
    stat = get_stat(Pathname(@dir_path).join(@segment))
    choose(stat)
  end

  private

  def tab_size
    TAB_SIZE
  end

  def space_size
    SPACE_SIZE
  end

  def get_stat(path)
    # File.statにシンボリックリンクのパスを入れると例外となる
    # その場合File.lstatにパスを入れる
    # File.lstatで例外となる場合異常終了とする
    File.stat(path)
  rescue SystemCallError
    File.lstat(path)
  end
end
