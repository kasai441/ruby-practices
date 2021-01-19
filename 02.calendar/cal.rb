#!/usr/bin/env ruby

require "date"

# 日付の文字数を２にする
def twoLetter(str)
  if str.length == 1
    str = " " + str
  else
    str
  end
end

# 日付を確定
disp_day = Date.today
disp_month = disp_day.month
disp_year = disp_day.year

weeks = []
weeks << (" " * 5) + twoLetter(disp_month.to_s) + "月 " + disp_year.to_s + (" " * 9)
weeks << "日 月 火 水 木 金 土  "

# その月の1日の曜日
write_day = Date.new(disp_year, disp_month, 1)
start_cw = write_day.cwday

# 7日ずつ文字列の配列を作る
start_flg = false
while write_day.month == disp_month do
  write_week = ""
  7.times do |n|
    next if write_day.month != disp_month
    n -= 1
    n = 7 if n < 0
    if start_cw != n && !start_flg
      write_week += " " * 2
      start_flg = true
    else
      write_week += twoLetter(write_day.day.to_s)
      write_day += 1
    end
    write_week += " "
  end
  weeks << write_week + " "
end

# 配列を表示
# weeks << "                1  2  "
weeks.each { |e| puts e }

