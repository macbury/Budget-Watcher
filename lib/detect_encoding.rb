require "rubygems"
require "iconv"

text = File.open(ARGV[0]).read

puts "text"

Encoding.aliases.keys.each do |encoding|
  begin
    converted_text = Iconv.conv(encoding, 'utf-8', text)
  rescue
    puts "NOT #{encoding}"
    next
  end
  puts encoding
end