module NaughtyP
  class Parser

    WRITE_OPERATOR = "WRITE"
    READ_OPERATOR = "READ"
    ASSIGN_OPERATOR = ":="
    SEMICOLON = ";"

    def initialize(source, file_name)
      @scanner = Scanner.new(source)
      @local_variables = Hash.new
      @emitter = Emitter.new(file_name)
    end

    def add_variable(name, value = 0)
      local_variable = LocalVariable.new
      local_variable.name = name
      local_variable.value = value
      local_variable.store_index = @local_variables.length
      @local_variables[name] = local_variable
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
        #@local_variables[variable_token.value] = @local_variables.length
        add_variable(variable_token.value)
        @emitter.read_int(@local_variables[variable_token.value].store_index)
        eval_source
      end
      if next_token.type == PToken::KEYWORD && next_token.value == WRITE_OPERATOR
        variable_token = @scanner.next_token
        if variable_token.type != PToken::IDENT
          raise "Variable expected"
        end
        semicolon_token = @scanner.next_token
        if semicolon_token.type != PToken::SEMICOLON
          raise "Semicolon expected"
        end
        @emitter.print_read_int(@local_variables[variable_token.value].store_index)
        eval_source
      end
      if next_token.type == PToken::IDENT
        assign_token = @scanner.next_token
        if assign_token.value != ASSIGN_OPERATOR
          raise "Assign operator expected"
        end
        variable_value = eval_expression
        semicolon_token = @scanner.next_token
        if semicolon_token.type != PToken::SEMICOLON
          raise "Semicolon expected"
        end
        @emitter.create_local_variable(@local_variables.length, variable_value)
        add_variable(next_token.value, variable_value)
        #@local_variables[next_token.value] = @local_variables.length
        eval_source
      end
    end

    def build
      file_builder = @emitter.build
      file_builder.generate do |filename, class_builder|
        File.open(filename, 'w') do |file|
          file.write(class_builder.generate)
        end
      end
    end

    def eval_expression
      token = @scanner.next_token

      case token.type
        when PToken::SPECIAL_SYMBOL
          if token.value == "("
            result = eval_expression
            bracket_token = @scanner.next_token
            if bracket_token.type == PToken::SPECIAL_SYMBOL && bracket_token.value == ")"
              if @scanner.peek.type != PToken::EOF && @scanner.peek.value != ")"
                @scanner.next_token
                return result + eval_expression
              end
              return result
            else
              raise "closing bracket expected"
            end
          else
            raise "opening bracket expected"
          end
        else
          return eval_next(token)
      end
    end

    def eval_next(token)
      token_value = token.value
      if token.type == PToken::IDENT
        if @local_variables.has_key? token_value
          token_value = @local_variables[token_value].value
        else
          raise "Unrecognised variable " + token.value
        end
      end
      next_token = @scanner.peek
      if next_token.type == PToken::EOF || next_token.value == ")" || next_token.type == PToken::SEMICOLON
        return Integer(token_value)
      end
      next_token = @scanner.next_token
      case next_token.value
        when "+"
          return token_value + eval_expression
        when "-"
          return token_value - eval_expression
        when "*"
          after_next_token = @scanner.peek
          if after_next_token.type == PToken::NUMERIC
            @scanner.next_token
            if @scanner.peek.value == "+"
              @scanner.next_token
              return token_value * after_next_token.value + eval_expression
            end
            return token_value * after_next_token.value
          end
          return token_value * eval_expression
        when "DIV"
          return token_value / eval_expression
        else
          #invalid token event
          raise "Invalid token in expression"
      end
    end
  end

  class LocalVariable
    attr_accessor :name, :value, :store_index
  end
end