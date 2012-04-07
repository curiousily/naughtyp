require "naughty_p"
require "spec_helper"
include NaughtyP

describe "Scanner#next_token" do

  it "should return EOF token when empty source is passed" do
    next_token_type_of("").should eql_token_type PToken::EOF
  end

  it "should return EOF token when source contains only empty spaces" do
    next_token_type_of("  ").should eql_token_type PToken::EOF
  end

  it "should return Number token when source contains 12345" do
    next_token_type_of("12345").should eql_token_type PToken::NUMERIC
  end

  it "should return 123 when source contains '123'" do
    next_token_value_of("123").should eql_token_value 123
  end

  it "should return Semicolon token when source has only semicolon" do
    next_token_type_of(";").should eql_token_type PToken::SEMICOLON
  end

  it "should return Ident token when source contains 'ABC'" do
    next_token_type_of("ABC").should eql_token_type PToken::IDENT
  end

  it "should return ABC token value when source contains 'ABC'" do
    next_token_value_of("ABC").should eql_token_value "ABC"
  end

  it "should return Ident token when source contains 'ABC '" do
    next_token_type_of("ABC ").should eql_token_type PToken::IDENT
  end

  it "should return Keyword token when source contains 'DIV'" do
    next_token_type_of("DIV").should eql_token_type PToken::KEYWORD
  end

  it "should return MOD token value when source contains 'MOD '" do
    next_token_type_of("MOD ").should eql_token_type PToken::KEYWORD
  end

  it "should return SpecialSymbol token when source contains ')'" do
    next_token_type_of(")").should eql_token_type PToken::SPECIAL_SYMBOL
  end

  it "should return SpecialSymbol token when source contains ':='" do
    next_token_type_of(":=").should eql_token_type PToken::SPECIAL_SYMBOL
  end

  it "should return := value when source contains ':= '" do
    next_token_value_of(":=").should eql_token_value ":="
  end

  it "should return KEYWORD token when source contains 'IFF'" do
    next_token_type_of("IFF").should eql_token_type PToken::KEYWORD
  end

  it "should return 'IFF' value when source contains 'IFF'" do
    next_token_value_of("IFF").should eql_token_value "IFF"
  end

  it "should return SpecialSymbol token when source contains 'ABC :=' and next_token is called 2 times" do
    scanner = scanner_for("ABC :=")
    scanner.next_token
    token_type_of(scanner.next_token).should eql_token_type PToken::SPECIAL_SYMBOL
  end

  it "should return Numeric token when source contains 'ABC := 123' and next_token is called 3 times" do
    scanner = scanner_for("ABC := 123")
    scanner.next_token
    scanner.next_token
    token_type_of(scanner.next_token).should eql_token_type PToken::NUMERIC
  end

  it "should return 123 token value when source contains 'ABC := 123' and next_token is called 3 times" do
    scanner = scanner_for("ABC := 123")
    scanner.next_token
    scanner.next_token
    token_value_of(scanner.next_token).should eql_token_value 123
  end

  it "should return Keyword token when source contains '2DIV3' and next_token is called 2 times" do
    scanner = scanner_for("2DIV3")
    scanner.next_token
    token_type_of(scanner.next_token).should eql_token_type PToken::KEYWORD
  end

  it "should return 'WRITE' token value when source is new_line_test.np and next_token is called 2 times" do
    scanner = scanner_from_file("test_files/new_line_test.np")
    scanner.next_token
    token_value_of(scanner.next_token).should eql_token_value "WRITE"
  end

  it "should raise UnexpectedCharacterError error when source is '!'" do
    expect do
      scanner_for("!").next_token
    end.to raise_error(UnrecognisedCharacterError)
  end
end

describe "Scanner#peek_next" do

  it "should have 'ABC' value for peek token when source contains 'ABC 2'" do
    scanner = scanner_for("ABC 2")
    peek_token = scanner.peek
    token_value_of(peek_token).should eql_token_value "ABC"
  end

  it "should have 'ABC' value for next token value when source contains 'ABC 2' and peek is called 1 time" do
    scanner = scanner_for("ABC 2")
    scanner.peek
    next_token = scanner.next_token
    token_value_of(next_token).should eql_token_value "ABC"
  end

end