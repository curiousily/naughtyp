require "naughty_p"

describe "Scanner#next_token" do
  include NaughtyP
  it "should return EOF token when empty source is passed" do
    eof_token = NaughtyP::Token.new(Token::EOF)
    Scanner.new("").next_token.should eql(eof_token)
  end

  it "should return Number token when source contains a number" do
    num_token = NaughtyP::Token.new(Token::NUMERIC, 12345)
    Scanner.new("12345").next_token.should eql(num_token)
  end

  it "should return proper number when source contains a number" do
    Scanner.new("123").next_token.should eql(NaughtyP::Token.new(Token::NUMERIC, 123))
  end

  it "should return semicolon when source has only semicolon" do
    Scanner.new(";").next_token.should eql(NaughtyP::Token.new(Token::SEMICOLON))
  end

  it "should return EOF token when source contains only empty spaces" do
    Scanner.new("   ").next_token.should eql(NaughtyP::Token.new(Token::EOF))
  end

end