require './redcloth_ext'

class Page
  attr_reader :name, :content, :args, :title, :childs, :tags

  def initialize(name, content, args)
    @name = name
    @content = content
    @args = args
    @title = args[:title] || name.capitalize
    @tags = args[:tags] ? args[:tags].strip.split(/\s*,\s*/) : []
    @childs = []
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

  def get_binding;   binding; end
  def to_html;       @html ||= RedCloth.new(content).to_html; end
end

class Post < Page
  attr_reader :date

  def initialize(name, content, args)
    super
    @date = Date.parse(args[:date]) or throw Exception.new("#{name} has an invalid date")
    @tags << 'blog'
  end

  def blog_post?;    true; end
  def monthly;       date.strftime("%b %Y"); end
  def yearly;        date.strftime("%Y"); end
end