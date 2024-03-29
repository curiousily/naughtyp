module NaughtyP
  class PToken

    attr_accessor :type, :value

    EOF = 1
    NUMERIC = 2
    SEMICOLON = 3
    IDENT = 4
    KEYWORD = 5
    SPECIAL_SYMBOL = 6

    def initialize(type, value = nil)
      @type = type
      @value = value
    end

  end
end