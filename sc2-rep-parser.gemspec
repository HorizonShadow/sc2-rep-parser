$:.push File.expand_path("../lib", __FILE__)
require 'sc2repparser/version'
Gem::Specification.new do |s|
  s.name = "sc2-rep-parser"
  s.version = Sc2RepParser::VERSION
  s.date = '2017-01-20'
  s.summary = 'Gets some player and game info from a .SC2Replay'
  s.authors = ['Joshua LeBlanc']
  s.email = 'joshleblanc94@gmail.com'
  s.files = Dir.glob "lib/**/*"
end
