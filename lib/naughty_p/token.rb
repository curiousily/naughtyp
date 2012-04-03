module NaughtyP
  class PToken

    attr_reader :type, :value

    EOF = 1
    NUMERIC = 2
    SEMICOLON = 3
    IDENT = 4
    KEYWORD = 5

    def initialize(type, value = nil)
      @type = type
      @value = value
    end

    def eql?(other)
      @type.eql?(other.type) and @value.eql?(other.value)
    end


  end
end