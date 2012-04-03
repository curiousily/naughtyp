module NaughtyP
  class Scanner
    def initialize source_code
      @source_code = source_code.chars.to_a
      @current_char_position = 0
      @next_char = @source_code[@current_char_position]
    end

    def next_token
      skip_white_space
      return NaughtyP::Token.new(Token::EOF) if @current_char_position >= @source_code.length
      if digit?(@next_char)
        value = @next_char.to_s
        read_next_char
        while bounded_by?(@current_char_position, @source_code.length) && digit?(@next_char)
          value << @next_char
          read_next_char
        end
        return NaughtyP::Token.new(Token::NUMERIC, Integer(value))
      end
      if letter?(@next_char)
        value = @next_char.to_s
        read_next_char
        while bounded_by?(@current_char_position, @source_code.length) && (letter?(@next_char) || digit?(@next_char))
          value << @next_char
          read_next_char
        end
        return NaughtyP::Token.new(Token::IDENT, value)
      end
      if @next_char == ';'
        NaughtyP::Token.new(Token::SEMICOLON)
      end
    end

    def read_next_char
      @current_char_position += 1
      @next_char = @source_code[@current_char_position]
    end

    def digit?(char)
      char >= '0' && char <= '9'
    end

    def letter?(char)
      char >= 'a' && char <= 'z' || char >= 'A' && char <= 'Z' || char == '_'
    end

    def bounded_by?(item, upper_bound)
      item < upper_bound
    end

    def self.from_file filename
      Scanner.new(IO.read(filename))
    end

    private

    def skip_white_space()
      while @next_char == ' '
        @current_char_position += 1
        @next_char = @source_code[@current_char_position]
      end
    end
  end
end