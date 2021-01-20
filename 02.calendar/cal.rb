#!/usr/bin/env ruby

require "date"

# 日付の文字数を２にする
def twoLetter(str)
	str = str.to_s
  if str.length == 1
    str = " " + str
  else
    str
  end
end

ARGV.each_with_index do |arg, i|
  puts "ARGV[#{i}]：#{arg}"
end

thatdate = Date.today
disp_month = thatdate.month
disp_year = thatdate.year

options = { m: "-m", y: "-y" }

begin
  ARGV.each_with_index do |e, idx|
		unless options.values.include?(e)
		  # オプション以外の引数が最初に与えられた場合
    	if idx == 0
				raise StandardError.new('first argument must be an option')
			# オプション以外の引数が２つ続いている場合
			elsif !options.values.include?(ARGV[idx - 1])
				raise StandardError.new('the argument other than option must not be next to another') 
			end		
		end
	end
rescue => e
  p "不正な引数です"
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

# 初期化
weeks = []
weeks << (" " * 5) + twoLetter(disp_month) + "月 " + disp_year.to_s + (" " * 9)
weeks << "日 月 火 水 木 金 土  "

# その月の1日の曜日
begin
	write_date = Date.new(disp_year, disp_month, 1)
rescue => e
	p "不正な日付の指定です"
	p e
	return
end
start_cw = write_date.cwday

# 7日ずつ文字列の配列を作る
start_flg = false
while write_date.month == disp_month do
  write_week = ""
  7.times do |n|
    next if write_date.month != disp_month
    n = 7 if n == 0
    if start_cw != n && !start_flg
      write_week += " " * 2
    else
			write_day = twoLetter(write_date.day)
			# 今日の場合、着色
	    if write_date == thatdate 
				write_day = "\e[30m\e[47m" + write_day + "\e[0m"	
			end
      write_week += write_day
      write_date += 1
      start_flg = true
    end
    write_week += " "
  end
  weeks << write_week + " "
end

# 配列を表示
weeks.each { |e| puts e }

