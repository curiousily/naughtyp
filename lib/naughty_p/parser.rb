module NaughtyP
  class Parser

    WRITE_OPERATOR = "WRITE"
    READ_OPERATOR = "READ"
    IFF_OPERATOR = "IFF"
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

    def add_variable(name, value = 0, from_read = false)
      local_variable = LocalVariable.new
      local_variable.name = name
      local_variable.value = value
      local_variable.store_index = @local_variables.length
      local_variable.from_read = from_read
      @local_variables[name] = local_variable
    end

    def eval_source
      next_token = @scanner.next_token
      if next_token.type == PToken::KEYWORD && next_token.value == READ_OPERATOR
        eval_read_operator
      end
      if next_token.type == PToken::KEYWORD && next_token.value == WRITE_OPERATOR
        eval_write_operator
      end
      if next_token.type == PToken::KEYWORD && next_token.value == IFF_OPERATOR
        eval_iff_statement
      end
      if next_token.type == PToken::IDENT
        eval_identifier(next_token.value)
      end
    end

    def eval_expression
      token_value = eval_brackets
      if token_value.nil?
        token_value = eval_local_variable(@scanner.next_token).value
      end

      sign_token = @scanner.peek
      if sign_token.type == PToken::EOF || sign_token.value == CLOSING_BRACKET || sign_token.type == PToken::SEMICOLON || sign_token.value == ","
        return Integer(token_value)
      end
      sign_token = @scanner.next_token
      case sign_token.value
        when "+"
          return token_value + eval_expression
        when "-"
          return token_value - eval_expression
        when "*"
          return multiply(token_value)
        when "DIV"
          return divide(token_value)
        else
          raise "Invalid token in expression"
      end
    end

    def build
      @emitter.build
    end

    private

    def eval_read_operator
      variable_token = @scanner.next_token
      check_identifier(variable_token.type)
      check_semicolon
      add_variable(variable_token.value, 0, true)
      @emitter.read_int(@local_variables[variable_token.value].store_index)
      eval_source
    end

    def check_identifier(token_type)
      if token_type != PToken::IDENT
        raise "Variable expected"
      end
    end

    def eval_write_operator
      next_token = @scanner.peek
      variable = @local_variables[next_token.value]
      if variable != nil && variable.from_read
        @scanner.next_token
        check_semicolon
        @emitter.print_read_int(variable.store_index)
      else
        expression_value = eval_expression
        check_semicolon
        @emitter.print_int(@local_variables.length, expression_value)
      end
      eval_source
    end

    def eval_iff_statement
      next_token = @scanner.next_token
      if next_token.value != OPENING_BRACKET
        raise "Opening bracket expected!"
      end
      expression_result = eval_expression
      next_token = @scanner.next_token
      if next_token.value != ","
        raise "Comma expected"
      end
      true_expression_result = eval_expression
      next_token = @scanner.next_token
      if next_token.value != ","
        raise "Comma expected"
      end
      false_expression_result = eval_expression
      next_token = @scanner.next_token
      if next_token.value != CLOSING_BRACKET
        raise "Closing bracket expected"
      end
      check_semicolon
      if expression_result > 0
        true_expression_result
      else
        false_expression_result
      end
    end

    def check_semicolon
      semicolon_token = @scanner.next_token
      if semicolon_token.type != PToken::SEMICOLON
        raise "Semicolon expected"
      end
    end

    def eval_identifier(name)
      assign_token = @scanner.next_token
      if assign_token.value != ASSIGN_OPERATOR
        raise "Assign operator expected"
      end
      if @scanner.peek.value == "IFF"
        @scanner.next_token
        variable_value = eval_iff_statement
      else
        variable_value = eval_expression
        semicolon_token = @scanner.next_token
        if semicolon_token.type != PToken::SEMICOLON
          raise "Semicolon expected"
        end
      end
      @emitter.create_local_variable(@local_variables.length, variable_value)
      add_variable(name, variable_value)
      eval_source
    end

    def eval_brackets
      token = @scanner.peek
      if token.value == OPENING_BRACKET
        @scanner.next_token
        result = eval_expression
        bracket_token = @scanner.next_token
        if bracket_token.value == CLOSING_BRACKET
          return result
        else
          raise "closing bracket expected"
        end
      end
      nil
    end

    def eval_local_variable(token)
      token_value = token.value
      if token.type == PToken::IDENT
        if @local_variables.has_key? token_value
          token.value = @local_variables[token_value].value
          token.type = PToken::NUMERIC
        else
          raise "Unrecognised variable " + token.value
        end
      end
      token
    end

    def multiply(left_hand_value)
      make_high_precedence_operation(left_hand_value, "*")
    end

    def divide(left_hand_value)
      make_high_precedence_operation(left_hand_value, "/")
    end

    def make_high_precedence_operation(left_hand_value, operation)
      right_hand_token = eval_local_variable(@scanner.peek)
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
    attr_accessor :name, :value, :store_index, :from_read
  end
end