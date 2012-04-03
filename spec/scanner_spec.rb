require "naughty_p"
include NaughtyP

describe "Scanner#next_token" do

  it "should return EOF token when empty source is passed" do
    Scanner.new("").next_token.should eql(NaughtyP::Token.new(Token::EOF))
  end

  it "should return Number token when source contains a number" do
    num_token = NaughtyP::Token.new(Token::NUMERIC, 12345)
    Scanner.new("12345").next_token.should eql(num_token)
  end

  it "should return proper number when source contains a number" do
    num_token = NaughtyP::Token.new(Token::NUMERIC, 123)
    Scanner.new("123").next_token.should eql(num_token)
  end

  it "should return semicolon token when source has only semicolon" do
    Scanner.new(";").next_token.should eql(NaughtyP::Token.new(Token::SEMICOLON))
  end

  it "should return EOF token when source contains only empty spaces" do
    Scanner.new("   ").next_token.should eql(NaughtyP::Token.new(Token::EOF))
  end

  it "should return Ident token when source contains ABC" do
    Scanner.new("ABC").next_token.should eql(NaughtyP::Token.new(Token::IDENT, "ABC"))
  end

end