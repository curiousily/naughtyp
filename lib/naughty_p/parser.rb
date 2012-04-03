module NaughtyP
  class Parser

    def eval_expression(expression)
      lexer = Lexer.new(expression)
      token = lexer.next_token
      next_token = lexer.next_token
      if next_token.type == PToken::EOF
        return Integer(token.value)
      end
      case next_token.value
        when "+"
          return token.value + lexer.next_token.value
        when "-"
          return token.value - lexer.next_token.value
        when "*"
          return token.value * lexer.next_token.value
        when "DIV"
          return token.value / lexer.next_token.value
        else
          #invalid token event
          raise "Invalid token in expression"
      end
    end
  end
end