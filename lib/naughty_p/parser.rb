module NaughtyP
  class Parser

    WRITE_OPERATOR = "WRITE"
    READ_OPERATOR = "READ"

    def initialize(source, file_name)
      @scanner = Scanner.new(source)
      @local_variables = Hash.new
      @emitter = Emitter.new(file_name)
    end

    def eval_source
      next_token = @scanner.next_token
      if next_token.type == PToken::KEYWORD && next_token.value == READ_OPERATOR
        variable_token = @scanner.next_token
        if variable_token.type != PToken::IDENT
          raise "Variable expected"
        end
        semicolon_token = @scanner.next_token
        if semicolon_token.type != PToken::SEMICOLON
          raise "Semicolon expected"
        end
        @local_variables[variable_token.value] = @local_variables.length
        @emitter.read_int(@local_variables[variable_token.value])
      end
      next_token = @scanner.next_token
      if next_token.type == PToken::KEYWORD && next_token.value == WRITE_OPERATOR
        variable_token = @scanner.next_token
        if variable_token.type != PToken::IDENT
          raise "Variable expected"
        end
        semicolon_token = @scanner.next_token
        if semicolon_token.type != PToken::SEMICOLON
          raise "Semicolon expected"
        end
        @emitter.print_read_int(@local_variables[variable_token.value])
      end

    end

    def build
      @emitter.print_int(@local_variables.length, 15)
      file_builder = @emitter.build
      file_builder.generate do |filename, class_builder|
        File.open(filename, 'w') do |file|
          file.write(class_builder.generate)
        end
      end
    end

    def eval_expression(expression)
      scanner = Scanner.new(expression)
      eval(scanner)
    end

    def eval(scanner)
      token = scanner.next_token
      case token.type
        when PToken::SPECIAL_SYMBOL
          if token.value == "("
            result = eval(scanner)
            bracket_token = scanner.next_token
            if bracket_token.type == PToken::SPECIAL_SYMBOL && bracket_token.value == ")"
              if scanner.peek.type != PToken::EOF && scanner.peek.value != ")"
                scanner.next_token
                return result + eval(scanner)
              end
              return result
            else
              raise "closing bracket expected"
            end
          else
            raise "opening bracket expected"
          end
        else
          return eval_next(scanner, token.value)
      end
    end

    def eval_next(scanner, token_value)
      next_token = scanner.peek
      if next_token.type == PToken::EOF || next_token.value == ")"
        return Integer(token_value)
      end
      next_token = scanner.next_token
      case next_token.value
        when "+"
          return token_value + eval(scanner)
        when "-"
          return token_value - eval(scanner)
        when "*"
          after_next_token = scanner.peek
          if after_next_token.type == PToken::NUMERIC
            scanner.next_token
            if scanner.peek.value == "+"
              scanner.next_token
              return token_value * after_next_token.value + eval(scanner)
            end
            return token_value * after_next_token.value
          end
          return token_value * eval(scanner)
        when "DIV"
          return token_value / eval(scanner)
        else
          #invalid token event
          raise "Invalid token in expression"
      end
    end
  end
end