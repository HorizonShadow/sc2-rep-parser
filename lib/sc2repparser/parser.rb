require_relative 'serialized.rb'
require_relative 'player.rb'

module Sc2RepParser
  class Parser
    SUPPORTED_VERSIONS = [
      [3, 9, 1],
      [3, 10, 0]
    ]
    attr_reader :data
    def initialize(file)
      @file = File.new file, "rb"
      @data = parse
    end
  
    private 
    def parse
      verify_mpq!
      skip! 5
      offset = get_offset
      skip! 4
      header = Serialized.deserialize(@file)
      p header[1][1..3]
      raise "invalid version" unless SUPPORTED_VERSIONS.include? header[1][1..3]
      skip! offset - @file.pos
      skip! 4
      second_offset = get_offset
      @file.pos = ((@file.pos - 8) * 2) + second_offset
      replay = Serialized.deserialize(@file)
      {
        header: header,
        replay: replay,
        players: parse_players(replay), 
        map: replay[1],
        server: replay[10].first[6...8],
        time: (replay[5] - 116444735995904000) / (10 ** 7)
      }
    end
  
    def parse_players(replay)
      replay[0].map do |player|
        Player.new(
          player[0],
          {
            region: player[1][0],
            unknown: player[1][1],
            num: player[1][2],
            real_id: player[1][3]
          },
          player[2],
          {
            alpha: player[3][0],
            red: player[3][1],
            green: player[3][2],
            blue: player[3][3]
          },
          player[4],
          player[5],
          player[6],
          player[7],
          player[8]
        )
      end
    end
  
    def verify_mpq!
      header = @file.read(3)
      raise "Invalid file" unless header == "MPQ"
    end
  
    def get_offset
      @file.read(4).unpack('v')[0]
    end
  
    def skip!(n)
      @file.read n
    end
  
  end
end
