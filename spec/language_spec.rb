require "naughty_p"
require "spec_helper"
include NaughtyP

describe "NaughtyP#interpret" do
  it "should write '10\n' to the output when interpreting WriteVariable.np" do
    interpretation_should_eql("WriteVariable.np", "10\n")
  end

  it "should write '15\n' to the output when interpreting WriteSum.np" do
    interpretation_should_eql("WriteSum.np", "15\n")
  end

  it "should write '20\n' to the output when interpreting WriteMultiplicationVariable.np" do
    interpretation_should_eql("WriteMultiplicationVariable.np", "20\n")
  end

  it "should write '12\n' to the output when interpreting ComplexExpression.np" do
    interpretation_should_eql("ComplexExpression.np", "12\n")
  end

  it "should write '22\n' to the output when interpreting ComplexVariables.np" do
    interpretation_should_eql("ComplexVariables.np", "22\n")
  end

  it "should write '11\n' to the output when interpreting ComplexVariables2.np" do
    interpretation_should_eql("ComplexVariables2.np", "11\n")
  end

  it "should write '25\n' to the output when interpreting VariableAssignments.np" do
    interpretation_should_eql("VariableAssignments.np", "25\n")
  end

  it "should write '5\n' to the output when interpreting IffStatement.np" do
    interpretation_should_eql("IffStatement.np", "5\n")
  end

  it "should write '8\n' to the output when interpreting IffFalseStatement.np" do
    interpretation_should_eql("IffFalseStatement.np", "8\n")
  end
end