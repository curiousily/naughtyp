require "set"

module NaughtyP
  class Scanner

    def initialize source_code
      @source_code = source_code.chars.to_a
      @current_char_position = 0
      @next_char = @source_code[@current_char_position]
      @keywords = Set.new %W(OR DIV MOD AND NOT READ WRITE)
      @special_symbols = Set.new %w{( ) + - * :=}
    end

    def next_token
      skip_white_space
      return PToken.new(PToken::EOF) if @current_char_position >= @source_code.length
      if digit?(@next_char)
        value = @next_char.to_s
        read_next_char
        while bounded_by?(@current_char_position, @source_code.length) && digit?(@next_char)
          value << @next_char
          read_next_char
        end
        return PToken.new(PToken::NUMERIC, Integer(value))
      end
      if letter?(@next_char)
        value = @next_char.to_s
        read_next_char
        while bounded_by?(@current_char_position, @source_code.length) && (letter?(@next_char) || digit?(@next_char))
          value << @next_char
          read_next_char
          if @keywords.include? value
            return PToken.new(PToken::KEYWORD, value)
          end
        end
        return PToken.new(PToken::IDENT, value)
      end
      if @special_symbols.include? @next_char
        token = PToken.new(PToken::SPECIAL_SYMBOL, @next_char.to_s)
        read_next_char
        return token
      end
      if @next_char == ':' && @source_code[@current_char_position + 1] == '='
        read_next_char
        read_next_char
        return PToken.new(PToken::SPECIAL_SYMBOL, ":=")
      end
      if @next_char == ';'
        read_next_char
        PToken.new(PToken::SEMICOLON)
      end
    end

    def peek
      return PToken.new(PToken::EOF) unless bounded_by?(@current_char_position, @source_code.length)
      old_char_position = @current_char_position
      old_next_char = @next_char[0]
      result = next_token
      @current_char_position = old_char_position
      @next_char = old_next_char.chr
      result
    end

    def self.from_file filename
      Scanner.new(IO.read(filename))
    end

    private

    def read_next_char
      @current_char_position += 1
      @next_char = @source_code[@current_char_position]
    end

    def skip_white_space
      while @next_char == ' '
        @current_char_position += 1
        @next_char = @source_code[@current_char_position]
      end
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
  end
end