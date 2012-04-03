require "naughty_p"
require "spec_helper"
include NaughtyP

describe "Scanner#next_token" do

  it "should return EOF token when empty source is passed" do
    next_token_for("").should eql(PToken.new(PToken::EOF))
  end

  it "should return EOF token when source contains only empty spaces" do
    next_token_for("   ").should eql(PToken.new(PToken::EOF))
  end

  it "should return Number token when source contains a number" do
    num_token = PToken.new(PToken::NUMERIC, 12345)
    next_token_for("12345").should eql(num_token)
  end

  it "should return 123 when source contains '123'" do
    num_token = PToken.new(PToken::NUMERIC, 123)
    next_token_for("123").should eql(num_token)
  end

  it "should return Semicolon token when source has only semicolon" do
    next_token_for(";").should eql(PToken.new(PToken::SEMICOLON))
  end

  it "should return Ident token when source contains 'ABC'" do
    next_token_for("ABC").should eql(PToken.new(PToken::IDENT, "ABC"))
  end

  it "should return Ident token when source contains 'ABC '" do
    next_token_for("ABC ").should eql(PToken.new(PToken::IDENT, "ABC"))
  end

  it "should return Keyword token when source contains 'DIV'" do
    next_token_for("DIV").should eql(PToken.new(PToken::KEYWORD, "DIV"))
  end

  it "should return MOD token value when source contains 'MOD '" do
    next_token_for("MOD ").should eql(PToken.new(PToken::KEYWORD, "MOD"))
  end
end