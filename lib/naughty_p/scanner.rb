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
        @current_char_position += 1
        @next_char = @source_code[@current_char_position]
        while bounded_by?(@current_char_position, @source_code.length) && digit?(@next_char)
          value << @next_char
          @current_char_position += 1
          @next_char = @source_code[@current_char_position]
        end
        return NaughtyP::Token.new(Token::NUMERIC, Integer(value))
      end
      if @next_char == ';'
        NaughtyP::Token.new(Token::SEMICOLON)
      end
    end

    def digit?(char)
      char >= '0' && char <= '9'
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