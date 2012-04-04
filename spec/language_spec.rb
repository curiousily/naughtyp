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
end