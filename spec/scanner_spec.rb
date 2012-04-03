require "naughty_p"
require "spec_helper"
include NaughtyP

describe "Scanner#next_token" do

  it "should return EOF token when empty source is passed" do
    next_token_for("").should eql(NaughtyP::Token.new(Token::EOF))
  end

  it "should return EOF token when source contains only empty spaces" do
    next_token_for("   ").should eql(NaughtyP::Token.new(Token::EOF))
  end

  it "should return Number token when source contains a number" do
    num_token = NaughtyP::Token.new(Token::NUMERIC, 12345)
    next_token_for("12345").should eql(num_token)
  end

  it "should return proper number when source contains '123'" do
    num_token = NaughtyP::Token.new(Token::NUMERIC, 123)
    next_token_for("123").should eql(num_token)
  end

  it "should return Semicolon token when source has only semicolon" do
    next_token_for(";").should eql(NaughtyP::Token.new(Token::SEMICOLON))
  end

  it "should return Ident token when source contains 'ABC'" do
    next_token_for("ABC").should eql(NaughtyP::Token.new(Token::IDENT, "ABC"))
  end

  it "should return Ident token when source contains 'ABC '" do
    next_token_for("ABC ").should eql(NaughtyP::Token.new(Token::IDENT, "ABC"))
  end
end