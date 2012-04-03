def eql_token_type(type)
  eql(token_type_of(token_with_type type))
end

def eql_token_value(value)
  eql(token_value_of(token_with_value value))
end

def token_with_type(type)
  PToken.new(type)
end

def token_with_value(value)
  PToken.new(nil, value)
end

def token_value_of(token)
  token.value
end

def token_type_of(token)
  token.type
end

def next_token_type_of(source_code)
  token_type_of(next_token_of(source_code))
end

def next_token_value_of(source_code)
  token_value_of(next_token_of(source_code))
end

def next_token_of(source_code)
  lexer_for(source_code).next_token
end

def lexer_for(source_code)
  Lexer.new(source_code)
end

def eval_expression(expression)
  Parser.new.eval_expression(expression)
end