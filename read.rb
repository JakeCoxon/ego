class Array 
  # maps an array into a hash
  def to_h(&block) 
    Hash[*self.map { |v| block.call(v) }.flatten(1)] 
  end
end


def parse_args(lines)
  args = {}
  if lines[0].strip == "---" then
    lines.shift()
    while (line = lines.shift()).strip != "---" do
      line.strip.match(/^(.+): (.+)$/) or raise Exception.new("Invalid argument #{line}")
      args[$1.to_sym] = $2
    end
  end
  args
end

def read_files_as_hash(glob)
  Dir.glob(glob).to_h do |filename|
    name = filename.match("/([a-zA-Z0-9\-]+)\.[^/]+$")[1]
    [name, yield(filename, name, IO.readlines(filename))]
  end
end

def read_pages(glob, type)
  read_files_as_hash glob do |filename, name, lines|
    args = parse_args(lines)
    type.new(name, lines.join, args)
  end
end
def read_layouts(glob)
  read_files_as_hash glob do |filename, name, lines|
    layout = ERB.new(lines.join)
    layout.filename = filename
    layout
  end
end

def write_page(file, content)
  File.open(file, 'w') do |file|
    file.write(content)
  end
  puts "Written: #{file}"
end