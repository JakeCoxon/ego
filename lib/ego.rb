require 'slim'
require 'RedCloth'

BASE = File.dirname(File.dirname(File.expand_path(__FILE__)))
require BASE + "/lib/ext/core.rb"
require BASE + "/lib/ext/redcloth.rb"
require BASE + "/lib/page.rb"

module Ego

  PAGE_MATCH = /\/(?<name>[a-zA-Z0-9\-]+)\.[^\/]+$/
  LAYOUT_MATCH = /\/(?<name>_?[a-zA-Z0-9\-]+)\.[^\/]+$/

  @layouts = []
  @pages = []

  def self.render(template, page)
    layout = @layouts[template] or raise Exception.new("Invalid template: #{template}")
    layout.render(page)
  end

  def self.read_files(glob, options)
    Dir.glob(glob).to_h do |filename|
      match = filename.match(options[:match]) and [match[:name], options[:as].new(filename)]
    end
  end

  def self.write_page(filename, content)
    File.open(filename, 'w') do |f|
      f.write(content) and puts "Written: #{filename.match(/\/([^\/]+)$/)[1]}"
    end
  end

  def self.process_tags(pages)
    pages.dup.each do |name, page|
      page.tags.each do |tag|
        (pages[tag] ||= Page.blank(tag)).childs << page
      end
    end
  end

  def self.generate!(dir)
    @pages = self.read_files "#{dir}/_pages/*.textile", :as => Page, :match => PAGE_MATCH
    @pages.merge! self.read_files "#{dir}/_posts/*.textile", :as => Post, :match => PAGE_MATCH
    @layouts = self.read_files "#{dir}/_layouts/*.slim", :as => Slim::Template, :match => LAYOUT_MATCH

    process_tags @pages

    @pages.each do |name, page|
      layout_name = page.args[:layout] || 'default'
      write_page("#{dir}/#{name}.html", render(layout_name, page))
    end
  end
  
end
