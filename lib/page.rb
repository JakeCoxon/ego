module Ego
  class Page
    attr_reader :name, :content, :args, :title, :childs, :tags

    def self.blank(name); Page.new(nil, name, ' '); end

    def initialize(filename, name=nil, content=nil)
      parse_frontmatter (content || IO.read(filename)).split $/

      @name = name || filename.match(PAGE_MATCH)[:name]
      @title = @args[:title] || @name.capitalize
      @tags = @args[:tags] ? @args[:tags].strip.split(/\s*,\s*/) : []
      @childs = []
    end

    def parse_frontmatter(lines)
      yaml = (lines[0].strip == "---" ?
        lines.drop_first.shift(lines.index {|l| l.strip == "---"} + 1).drop_last : nil)

      @args = yaml.to_h do |line|
        line.strip.match(/^(.+): (.+)$/) or raise Exception.new("Invalid arg: #{line}")
        [$1.to_sym, $2]
      end
    
      @content = lines.join $/
    end

    def child_posts;   @child_posts ||= @childs.select(&:blog_post?).reverse(); end
    def child_pages;   @child_pages ||= @childs.select(&:page?); end
    def page?;         !blog_post?; end
    def blog_post?;    false; end

    def has_posts?;    !child_posts.empty?; end
    def has_pages?;    !child_pages.empty?; end
    def has_arg?(arg); @args.has_key?(arg); end
    def has_tags?;     !@tags.empty?; end
    def has_childs?;   !@childs.empty?; end

    def partial(name); render(name, self); end
    def to_html;       @html ||= RedCloth.new(content).to_html; end
    def render(*args); Ego.render(*args); end
  end

  class Post < Page
    attr_reader :date

    def initialize(filename, name=nil, content=nil)
      super
      @date = Date.parse(@args[:date]) or throw Exception.new("#{name} has an invalid date")
      @tags << 'blog'
    end

    def blog_post?;    true; end
    def monthly;       date.strftime("%b %Y"); end
    def yearly;        date.strftime("%Y"); end
  end
end