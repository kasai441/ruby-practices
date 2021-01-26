path = ARGV[0]
p path
path = "#{Dir.home}" if path.nil?
items = []
files = []
row = []

Dir.open(path) do |d|
  d.children.each do |item|
    items << item
  end
end

puts 'items'
p items.sort { |a, b| a.gsub(/\./, '') <=> b.gsub(/\./, '') }
puts 

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

def divide_to_cols(files)
  cols = files.map { |e| [e] }
  (2..files.size).each do |n|
    unless within_width?(cols_to_rows(cols))
      sliced = files.dup
      cols.clear
      cols_size = files.size % n == 0 ? files.size / n : files.size / n + 1
      cols_size.times { cols << sliced.slice!(0, n) }
      puts "n:#{n}"
      p cols
      puts
    end
  end
  cols
end

files = items.sort { |a, b| a.gsub(/\./, '') <=> b.gsub(/\./, '') }

cols = divide_to_cols(files)

puts 'cols'
p cols
puts

rows = cols_to_rows(cols)

puts 'rows'
p rows
puts

# p files.map { |e| e.size }.sum
rows.each { |e| puts e.join('  ') }
#    printf("%1$s  ", item)
#    row += "  #{item}" if item.size   
print "\n"
p `tput cols`.gsub(/\D/, '').to_i

stat = File.stat("/home/kasai441/#{items[0]}")
puts stat.dev
puts stat.size
puts "0%o" % stat.mode
puts stat.mode
