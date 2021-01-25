# Dir.foreach('.') do |item|
path = ARGV[0]
Dir.open(path) do |d|
  d.children.each do |item|
    print item + "\t"
  end
end
print "\n"
