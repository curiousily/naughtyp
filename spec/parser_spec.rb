require "naughty_p"
require "spec_helper"
include NaughtyP

describe "Parser#eval_expression" do

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

  it "should evaluate to 2 when expression is '(2)'" do
    eval_expression("(2)").should eql 2
  end

  it "should evaluate to 4 when expression is '(2 + 2)'" do
    eval_expression("(2 + 2)").should eql 4
  end

  it "should evaluate to 6 when expression is '(3 * 2)'" do
    eval_expression("(3 * 2)").should eql 6
  end

  it "should evaluate to 9 when expression is '(5 + (2 * 2))'" do
    eval_expression("(5 + (2 * 2))").should eql 9
  end

  it "should evaluate to 9 when expression is '5 + 2 * 2'" do
    eval_expression("5 + 2 * 2").should eql 9
  end

  it "should evaluate to 9 when expression is '2 * 2 + 5'" do
    eval_expression("2 * 2 + 5").should eql 9
  end

  it "should evaluate to 19 when expression is '2 * 2 + (5 + 10)'" do
    eval_expression("2 * 2 + (5 + 10)").should eql 19
  end

  it "should evaluate to 19 when expression is '(2 * 2) + (5 + 10)'" do
    eval_expression("(2 * 2) + (5 + 10)").should eql 19
  end

  it "should evaluate to 11 when expression is '2 + (5 + 2 * 2)'" do
    eval_expression("2 + (5 + 2 * 2)").should eql 11
  end

  it "should evaluate to 11 when expression is '2+9;'" do
    eval_expression("2+9;").should eql 11
  end

  it "should evaluate to 2 when expression is '2;'" do
    eval_expression("2;").should eql 2
  end

  it "should evaluate to 2 when expression is 'A' and A is variable set to 2" do
    parser = parser_for("A")
    parser.add_variable("A", 2)
    parser.eval_expression.should eql 2
  end

  it "should evaluate to 4 when expression is 'A + 2' and A is variable set to 2" do
    parser = parser_for("A + 2")
    parser.add_variable("A", 2)
    parser.eval_expression.should eql 4
  end

  it "should evaluate to 4 when expression is 'A + A' and A is variable set to 2" do
    parser = parser_for("A + A")
    parser.add_variable("A", 2)
    parser.eval_expression.should eql 4
  end

  it "should evaluate to 5 when expression is 'A + B' and A is variable set to 2 and B is variable set to 3" do
    parser = parser_for("A + B")
    parser.add_variable("A", 2)
    parser.add_variable("B", 3)
    parser.eval_expression.should eql 5
  end

  it "should evaluate to 5 when expression is 'A + B;' and A is variable set to 2 and B is variable set to 3" do
    parser = parser_for("A + B;")
    parser.add_variable("A", 2)
    parser.add_variable("B", 3)
    parser.eval_expression.should eql 5
  end
end