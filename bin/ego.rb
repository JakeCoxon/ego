base = File.dirname(File.dirname(File.expand_path(__FILE__)))

require base + '/lib/ego.rb'

Ego.generate! base + '/site'