require 'erb'
require 'RedCloth'

require './read'
require './page.rb'

dir = 'site'

def process_tags(pages)
  newpages = {}
  pages.each do |name, page|
    page.tags.each do |tag|
      parent = pages[tag] || (newpages[tag] ||= Page.new(tag, "", {}))
      parent.childs << page
    end
  end
  pages.merge! newpages
end

pages = read_pages "#{dir}/_pages/*.textile", Page
pages.merge! read_pages "#{dir}/_posts/*.textile", Post
layouts = read_layouts "#{dir}/_layouts/*.html"

process_tags pages

pages.each do |name, page|
  layout_name = page.args[:layout] || 'default'
  layout = layouts[layout_name] or raise Exception.new("Invalid template: #{layout_name}")
  write_page("#{dir}/#{name}.html", layout.result(page.get_binding))
end

