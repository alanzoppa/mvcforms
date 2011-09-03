$test_env = true

require "./forms"
require "./fields"


describe "the symbolize method" do
  it "should replace spaces with underscores" do
    symbolize("foo bar baz").should == :foo_bar_baz
  end
end

describe "the wrap_tag method" do
  it "should wrap strings with <p> tags by default" do
    wrap_tag("derp").should == "<p>derp</p>"
  end

  it "should accept an arbitrary symbol or string to replace p" do
    wrap_tag("derp", with=:span).should == "<span>derp</span>"
  end
end

describe "the indent method" do
  before do
    @string = "Blinky,\nPinky,\nInky,\nClyde"
    @array = ["Blinky,", "Pinky,", "Inky,", "Clyde"]
  end


  it "should indent two lines by default" do
    indent(@string).should == "  Blinky,\n  Pinky,\n  Inky,\n  Clyde"
  end

  it "should handle a pre-split array" do
    indent(@array).should == "  Blinky,\n  Pinky,\n  Inky,\n  Clyde"
  end

  it "should indent by n lines" do
    indent(@string, :depth => 4).should == "    Blinky,\n    Pinky,\n    Inky,\n    Clyde"
  end

  it "should append line breaks if necessary" do
    indent(input=@string, :template => "%s\n", :depth => 4).should == "    Blinky,\n    Pinky,\n    Inky,\n    Clyde\n"
    indent(input=@string, :template => "%s\n").should == "  Blinky,\n  Pinky,\n  Inky,\n  Clyde\n"
  end

end
