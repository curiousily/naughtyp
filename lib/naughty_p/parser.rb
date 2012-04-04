module NaughtyP
  class Parser

    WRITE_OPERATOR = "WRITE"
    READ_OPERATOR = "READ"
    ASSIGN_OPERATOR = ":="
    SEMICOLON = ";"
    OPENING_BRACKET = "("
    CLOSING_BRACKET = ")"

    def initialize(source, file_name)
      @scanner = Scanner.new(source)
      @local_variables = Hash.new
      @emitter = Emitter.new(file_name)
    end

    def self.for_file(file_name)
      class_name = file_name.chomp(File.extname(file_name))
      Parser.new(IO.read(file_name), class_name)
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
        eval_source
      end
    end

    def build
      @emitter.build

    end

    def eval_expression
      token = @scanner.next_token
      if token.value == OPENING_BRACKET
        result = eval_expression
        bracket_token = @scanner.next_token
        if bracket_token.type == PToken::SPECIAL_SYMBOL && bracket_token.value == CLOSING_BRACKET
          if @scanner.peek.type != PToken::EOF && @scanner.peek.value != CLOSING_BRACKET
            @scanner.next_token
            return result + eval_expression
          end
          return result
        else
          raise "closing bracket expected"
        end
      else
        eval_next(token)
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
      if next_token.type == PToken::EOF || next_token.value == CLOSING_BRACKET || next_token.type == PToken::SEMICOLON
        return Integer(token_value)
      end
      next_token = @scanner.next_token
      case next_token.value
        when "+"
          return token_value + eval_expression
        when "-"
          return token_value - eval_expression
        when "*"
          return multiply(token_value)
        when "DIV"
          return divide(token_value)
        else
          #invalid token event
          raise "Invalid token in expression"
      end
    end

    def multiply(left_hand_value)
      make_high_precedence_operation(left_hand_value, "*")
    end

    def divide(left_hand_value)
      make_high_precedence_operation(left_hand_value, "/")
    end

    def make_high_precedence_operation(left_hand_value, operation)
      right_hand_token = @scanner.peek
      if right_hand_token.type == PToken::NUMERIC
        @scanner.next_token
        sign_token = @scanner.peek
        result = eval("left_hand_value #{operation} right_hand_token.value")
        if sign_token.value == "DIV"
          sign_token.value = "/"
        end
        recognised_operations = Set.new %W(+ - * /)
        if recognised_operations.include? sign_token.value
          @scanner.next_token
          eval("result #{sign_token.value} eval_expression")
        else
          result
        end
      end
    end
  end

  class LocalVariable
    attr_accessor :name, :value, :store_index
  end
end