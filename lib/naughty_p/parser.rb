module NaughtyP
  class Parser

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