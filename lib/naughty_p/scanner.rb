require "set"
require "naughty_p/exceptions/unrecognised_character_error"

module NaughtyP
  class Scanner

    def initialize source_code
      @source_code = source_code.scan(/./)
      @current_char_position = 0
      @next_char = @source_code[@current_char_position]
      @keywords = Set.new %W(OR DIV MOD AND NOT READ WRITE)
      @special_symbols = Set.new %w{( ) + - * :=}
    end

    def next_token
      skip_white_space
      if out_of_bounds?
        return eof_token
      end
      if digit?(@next_char)
        return next_numeric_token
      end
      if letter?(@next_char)
        return next_keyword_or_ident_token
      end
      if @special_symbols.include? @next_char
        return next_special_symbol_token
      end
      if assignment?
        return next_assignment_token
      end
      if semicolon?
        return next_semicolon_token
      end
      raise UnrecognisedCharacterError, @next_char.to_s
    end

    def assignment?
      @next_char == ':' && @source_code[@current_char_position + 1] == '='
    end

    def semicolon?
      @next_char == ';'
    end

    def out_of_bounds?
      @current_char_position >= @source_code.length
    end

    def eof_token
      PToken.new(PToken::EOF)
    end

    def next_numeric_token
      value = @next_char.to_s
      read_next_char
      while bounded_by?(@current_char_position, @source_code.length) && digit?(@next_char)
        value += @next_char
        read_next_char
      end
      PToken.new(PToken::NUMERIC, Integer(value))
    end

    def next_keyword_or_ident_token
      value = @next_char.to_s
      read_next_char
      while bounded_by?(@current_char_position, @source_code.length) && (letter?(@next_char) || digit?(@next_char))
        value += @next_char
        read_next_char
        if @keywords.include? value
          return PToken.new(PToken::KEYWORD, value)
        end
      end
      PToken.new(PToken::IDENT, value)
    end

    def next_special_symbol_token
      token = PToken.new(PToken::SPECIAL_SYMBOL, @next_char.to_s)
      read_next_char
      token
    end

    def next_assignment_token
      read_next_char
      read_next_char
      PToken.new(PToken::SPECIAL_SYMBOL, ":=")
    end

    def next_semicolon_token
      read_next_char
      PToken.new(PToken::SEMICOLON)
    end

    def peek
      old_char_position = @current_char_position
      old_next_char = @next_char
      result = next_token
      @current_char_position = old_char_position
      @next_char = old_next_char
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
      while @next_char == " " || @next_char == "\n"
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