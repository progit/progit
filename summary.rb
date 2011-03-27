#! /usr/bin/env ruby
#

command = ARGV[0]
exclude = ['figures', 'figures-dia', 'figures-source', 'couchapp', 'latex', 'pdf', 'epub', 'en', 'ebooks']

data = []
original_lines=`grep -r -h '^[^[:space:]#]' en/[0]* | grep -v '^Insert'| wc -l`.to_i
Dir.glob("*").each do |dir|
  if !File.file?(dir) && !exclude.include?(dir)
    lines = `git diff-tree -r -p --diff-filter=M master:en master:#{dir} | grep '^-[^[:space:]#-]' | grep -v '^-Insert' | wc -l`.strip.to_i
    last_commit = `git log -1 --no-merges --format="%ar" #{dir}`.chomp
    authors = ""
    if command == 'authors'
      authors = `git shortlog --no-merges -s -n #{dir}`.chomp
    end
    data << [dir, lines, authors, last_commit]
  end
end

d = data.sort { |a, b| b[1] <=> a[1] }
d.each do |dir, lines, authors, last|
  puts "#{dir.ljust(10)} - #{(lines*100)/original_lines}% (#{last})"
  if command == 'authors'
    puts "Authors: #{authors.split("\n").size}"
    puts authors 
    puts
  end
end
