def remove_args(lines)
  lines.drop_first.shift(lines.index {|l| l.strip == "---"} + 1).drop_last
end

def parse_args(lines)
  remove_args(lines).to_h do |line|
    line.strip.match(/^(.+): (.+)$/) or raise Exception.new("Invalid arg: #{line}")
    [$1.to_sym, $2]
  end if lines[0].strip == "---"
end

def read_files_as_hash(glob)
  Dir.glob(glob).to_h do |filename|
    name = filename.match("/([a-zA-Z0-9\-]+)\.[^/]+$")[1]
    [name, yield(filename, name, IO.readlines(filename))]
  end
end

def read_pages(glob, options)
  read_files_as_hash glob do |filename, name, lines|
    args = parse_args(lines) || {}
    options[:as].new(name, lines.join, args)
  end
end
def read_layouts(glob)
  read_files_as_hash glob do |filename, name, lines|
    ERB.new(lines.join).chain(:filename=, filename)
  end
end

def write_page(filename, content)
  File.open(filename, 'w') do |f|
    f.write(content) and puts "Written: #{filename}"
  end
end