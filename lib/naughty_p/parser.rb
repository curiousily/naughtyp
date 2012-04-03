module NaughtyP
  class Parser

    def eval_expression(expression)
      lexer = Lexer.new(expression)
      eval(lexer)
    end

    def eval(lexer)
      token = lexer.next_token
      case token.type
        when PToken::SPECIAL_SYMBOL
          if token.value == "("
            result = eval(lexer)
            bracket_token = lexer.next_token
            if bracket_token.type == PToken::SPECIAL_SYMBOL && bracket_token.value == ")"
              return result
            end
            raise "closing bracket expected"
          else
            raise "opening bracket expected"
          end
        else
          next_token = lexer.peek_next
          if next_token.type == PToken::EOF || next_token.value == ")"
            return Integer(token.value)
          end
          next_token = lexer.next_token
          case next_token.value
            when "+"
              return token.value + eval(lexer)
            when "-"
              return token.value - eval(lexer)
            when "*"
              return token.value * eval(lexer)
            when "DIV"
              return token.value / eval(lexer)
            else
              #invalid token event
              raise "Invalid token in expression"
          end
      end
    end
  end
end