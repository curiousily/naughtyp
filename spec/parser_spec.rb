require "naughty_p"
require "spec_helper"
include NaughtyP

describe "Parser#evaluate_expression" do

  it "should evaluate to 2 when expression is '2'" do
    eval_expression("2").should eql 2
  end

  it "should evaluate to 4 when expression is '2+2'" do
    eval_expression("2+2").should eql 4
  end

  it "should evaluate to 4 when expression is '2 + 2'" do
    eval_expression("2 + 2").should eql 4
  end

  it "should evaluate to 3 when expression is '5-2'" do
    eval_expression("5-2").should eql 3
  end

  it "should evaluate to 6 when expression is '3*2'" do
    eval_expression("3*2").should eql 6
  end

  it "should evaluate to 3 when expression is '6 DIV 2'" do
    eval_expression("6DIV2").should eql 3
  end
end