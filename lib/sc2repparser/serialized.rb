module Sc2RepParser
  class Serialized
    BYTE_STRING = 0x02
    ARRAY_OBJECT = 0x04
    KEY_VALUE_OBJECT = 0x05
    SINGLE_BYTE_INT = 0x06
    FOUR_BYTE_INT = 0x07
    VAR_LENGTH_INT = 0x09
  
    def initialize(file)
      @file = file
      deserialize
    end
    
    def self.deserialize(file)
      @file = file
      decode file.read(1)
    end
  
    private
    def self.decode(val)
      case val.ord
      when BYTE_STRING
        self.decode_byte_string
      when ARRAY_OBJECT
        self.decode_array_object
      when KEY_VALUE_OBJECT
        self.decode_key_value_object
      when SINGLE_BYTE_INT
        self.decode_single_byte_int
      when FOUR_BYTE_INT
        self.decode_four_byte_int
      when VAR_LENGTH_INT
        self.decode_var_length_int
      end
    end
  
    def self.decode_var_length_int
      arr = []
      loop do
        byte = @file.read(1).ord
        arr << ("%08b" % byte)[1..-1]
        break if byte < 128
      end
      arr.reverse.join.to_i(2) >> 1
    end
  
    def self.decode_four_byte_int
      @file.read(4).unpack('N')[0] >> 1  
    end
  
    def self.decode_single_byte_int
      @file.read(1).ord >> 1
    end
  
    def self.decode_array_object
      @file.read(2)
      length = @file.read(1).ord >> 1
      length.times.map do 
        decode @file.read(1)
      end
    end
  
    def self.decode_byte_string
      length = @file.read(1).ord >> 1
      a = @file.read(length)
    end
  
    def self.decode_key_value_object
      hex = @file.read(1)
      num_pairs = hex.ord >> 1
      num_pairs.times.map do
        @file.read(1)
        decode @file.read(1)
       # {
          #key: @file.read(1).ord >> 1,
       #   value: decode(@file.read(1)) 
       # }
      end
    end
  end
end
