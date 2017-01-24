require_relative 'parser.rb'
module Sc2RepParser
  class Sc2Replay
    attr_reader :players, :server, :map, :date
    def initialize(file_name)
      parser = Parser.new(file_name)
      @version = parser.data[:header][1]
      @players = parser.data[:players]
      @server = parser.data[:server]
      @map = parser.data[:map]
      @date = parser.data[:time]
    end

    def is_version(version)
      @version[1..3] == version
    end
  end
end
