require 'erb'
require 'RedCloth'

require './ext.rb'
require './read.rb'
require './page.rb'

dir = '../site'

def process_tags(pages)
  pages.dup.each do |name, page|
    page.tags.each do |tag|
      (pages[tag] ||= Page.new(tag, "", {})).childs << page
    end
  end
end

pages = read_pages "#{dir}/_pages/*.textile", :as => Page
pages.merge! read_pages "#{dir}/_posts/*.textile", :as => Post
layouts = read_layouts "#{dir}/_layouts/*.html"

process_tags pages

pages.each do |name, page|
  layout_name = page.args[:layout] || 'default'
  layout = layouts[layout_name] or raise Exception.new("Invalid template: #{layout_name}")
  write_page("#{dir}/#{name}.html", layout.result(page.get_binding))
end

