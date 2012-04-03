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

  it "should return Ident token when source contains 'ABC '" do
    next_token_type_of("ABC ").should eql_token_type PToken::IDENT
  end

  it "should return Keyword token when source contains 'DIV'" do
    next_token_type_of("DIV").should eql_token_type  PToken::KEYWORD
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
end