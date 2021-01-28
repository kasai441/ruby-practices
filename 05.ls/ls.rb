#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

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
  # Debian10/bash では"."及び大文字小文字は無視してソートする
  files = items.sort { |a, b| a.gsub(/^\./, '').downcase <=> b.gsub(/^\./, '').downcase }
  # -a オプション
  files.delete_if { |f| f.match?(/^\..*/) } if !a
  # -r オプション
  files.reverse! if r  

  files
end
 
def list_detail(path, files)
  path = to_readable(path)
  data = []
  blocks = 0
  files.each do |f|
    stat = get_stat(path, f)
    data << get_data(stat, path, f)
    blocks += stat.blocks
  end
  data = to_same_width(data)
  puts "total #{blocks}"
  data.each { |d| puts d.join(' ') }
end

def to_readable(path)
  # デフォルトで現在のフォルダを参照
  path = './' if !path
  # ディレクトリの最後に"/"がない場合、補完する
  path += '/' if !path.match?(/.*\/$/)
  path
end

def get_stat(path, f)
  # Mac/Ruby3.0.0 でFile.statにシンボリックリンクのパスを入れると例外となる(Debian10/Ruby2.7.1ではならない）その場合File.lstatにパスを入れる
  # File.lstatで例外となる場合、そのまま実行時例外で異常終了とする
  begin
    stat = File.stat(path + f)
  rescue
    stat = File.lstat(path + f)
  end
end

def get_data(stat, path, f)
  datum = []
  datum << to_char_ftype(stat.ftype) + to_char_mode(stat.mode)
  #p "0%o" % stat.mode
  datum << stat.nlink
  datum << Etc.getpwuid(stat.uid).name
  datum << get_group_name(stat.uid)
  datum << stat.size
  datum << stat.mtime.strftime("%b %d %H:%M")
  datum << (datum[0][0] == 'l' ? "#{f} -> #{File.readlink(path + f)}" : f)
  datum
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

def get_group_name(uid)
  # Linuxで作成したファイルのグループがMacにない場合エラーとなるので、その場合、Macのlsコマンドの動作に準じて'staff'というグループとみなす
  begin
    Etc.getgrgid(uid).name
  rescue
    'staff'
  end
end

def to_same_width(data)
  # maximize_colsメソッドを利用するために行列を入れ替える
  cols = convert_cols_rows(data)
  cols = maximize_cols(cols)
  # 改行するほど長いファイル名がある場合に全ての行で改行が起きてしまうのを防ぐため、ファイル名のみ、長さを元のままとして、揃えない
  cols.last.map! { |c| c.strip }
  # 入れ替えた行列を再度入れ替えて元に戻す
  convert_cols_rows(cols)  
end

def list_name(files)
  cols = divide_to_cols(files)
  rows = convert_cols_rows(cols)
  # Debian10/bashでは各列を最大文字列でそろえ間隔は空白二つ分
  rows.each { |e| puts e.join('  ') }
end

# Debian10/bashでのlsの動作に近似させる
def divide_to_cols(files)
  # 列数は最初はファイル数 行数は１
  cols = files.map { |e| [e] }
  # ターミナルの幅に収まるまで列数を減らしていく 行数を2から一つずつ増やす
  (2..files.size).each do |rows_num|
    unless within_display?(convert_cols_rows(cols))
      sliced = files.dup
      cols.clear
      cols_num = (files.size / rows_num.to_f).ceil
      cols_num.times { cols << sliced.slice!(0, rows_num) }
      cols = maximize_cols(cols)
    end
  end
  cols
end

def convert_cols_rows(items)
  result = []
  items[0].size.times { |id| result[id] = [] }

  items.each do |item|
    item.each_with_index do |file, id|
      result[id] << file
    end
  end
  result
end

def within_display?(rows)
  # ターミナル幅取得
  width = `tput cols`.gsub(/\D/, '').to_i
  rows.each do |row|
    return false if row.join('  ').size > width
  end
  true
end

def maximize_cols(cols)
  result = []
  cols.each do |col|
    max = col.map { |c| c.to_s.size }.max
    result << col.map do |c|
      if c.is_a?(String)
        c + ' ' * (max - c.size)
      elsif c.is_a?(Integer)
        ' ' * (max - c.to_s.size) + c.to_s
      end
    end
  end
  result
end

run_app
