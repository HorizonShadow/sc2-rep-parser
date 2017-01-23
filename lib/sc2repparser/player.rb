module Sc2RepParser
  class Player
    attr_reader :name, :id, :race, :color, :team, :outcome
    def initialize(name, id, race, color, unknown, team, handicap, unknown_2, outcome)
      @name = name
      @color = color 
      @id = id
      @race = race
      @unknown = unknown
      @team = team
      @handicap = handicap
      @unknown_2 = unknown_2
      @outcome = outcome
    end
  end
end
