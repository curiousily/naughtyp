require "java"

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
  scanner_for(source_code).next_token
end

def scanner_for(source_code)
  Scanner.new(source_code)
end

def scanner_from_file(filename)
  Scanner::from_file(filename)
end

def eval_expression(expression)
  parser_for(expression).eval_expression
end

def parser_for(source_code)
  Parser.new(source_code, "dummy_filename")
end

OUT_FILE = "out.txt"
EXAMPLES_DIR = "examples/"

def interpretation_should_eql(source_file, expected_result)
  output_stream = java.io.FileOutputStream.new(OUT_FILE)
  System.setOut(java.io.PrintStream.new(output_stream))
  NaughtyP::interpret(EXAMPLES_DIR + source_file)
  IO.read(OUT_FILE).should eql expected_result
  File.delete(OUT_FILE)
end