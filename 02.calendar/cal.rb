#!/usr/bin/env ruby

require "date"

# 日付の文字数を２にする
def keep_two_letter(str)
  str = str.to_s
  if str.length == 1
    str = ' ' + str
  else
    str
  end
end

thatdate = Date.today
disp_month = thatdate.month
disp_year = thatdate.year
disp_highlight = true

options = { m: '-m', y: '-y', h: '-h' }
single_options = ['-h']

# 引数の例外処理
begin
  ARGV.each_with_index do |e, idx|
    unless options.values.include?(e)
      # オプション以外の引数が最初に与えられた場合
      if idx == 0
        raise StandardError.new('最初の引数はオプションにしてください　オプション： ' + options.values.to_s)
      # オプション以外の引数がオプション指定のものでない場合
      elsif !(options.values - single_options).include?(ARGV[idx - 1])
        raise StandardError.new('オプション以外の引数を指定しないでください　オプション：' + options.values.to_s) 
      end    
    end
  end
rescue => e
  p '不正な引数です'
  p e
  return
end

# -m だったら
if idx = ARGV.index(options[:m])
  disp_month = ARGV[idx + 1].to_i
end

# -y だったら
if idx = ARGV.index(options[:y])
  disp_year = ARGV[idx + 1].to_i
end

# -h だったら
if idx = ARGV.index(options[:h])
  disp_highlight = false 
end

# 初期化
write_week = ''
write_week += (' ' * 5) + keep_two_letter(disp_month) + '月 ' + disp_year.to_s + (' ' * 9) + "\n"
write_week += '日 月 火 水 木 金 土  ' + "\n"

# その月の1日の曜日
begin
  write_date = Date.new(disp_year, disp_month, 1)
rescue => e
  p '不正な日付の指定です'
  p e
  return
end
start_cw = write_date.cwday

def write_blank_day(num)
  str = ''
  day_space = 3
  str += ' ' * num * day_space
end

cw = start_cw
# 最初の日までの空白
write_week += write_blank_day(cw)

# 月が変わるまで日付を加える
while write_date.month == disp_month do
  write_day = keep_two_letter(write_date.day)
  # 今日の場合、着色
  if write_date == thatdate && disp_highlight 
    write_day = "\e[7m" + write_day + "\e[0m"
  end
  write_week += write_day + ' '
  write_date += 1
  
  # 週の折り返し
  cw += 1
  if cw == 7
    cw = 0
    write_week += " \n"
  end
end

# 最後の日から行が終わるまでの空白
write_week += write_blank_day(7 - cw) + ' ' 

puts write_week
