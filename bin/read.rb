def remove_args(lines)
  lines.drop_first.shift(lines.index {|l| l.strip == "---"} + 1).drop_last if lines[0].strip == "---"
end

def parse_args(lines)
  return remove_args(lines).to_h do |line|
    line.strip.match(/^(.+): (.+)$/) or raise Exception.new("Invalid arg: #{line}")
    [$1.to_sym, $2]
  end, lines
end

def read_pages(glob, options)
  Dir.glob(glob).to_h do |filename|
    name = filename.match(/\/([a-zA-Z0-9\-]+)\.[^\/]+$/)[1]
    [name, options[:as].new(name, *parse_args(IO.readlines(filename)))]
  end
end

def read_layouts(glob)
  Dir.glob(glob).to_h do |filename|
    [$1, Slim::Template.new(filename)] if filename.match(/\/([_a-zA-Z0-9\-]+)\.[^\/]+$/)
  end
end

def write_page(filename, content)
  File.open(filename, 'w') do |f|
    f.write(content) and puts "Written: #{filename}"
  end
end