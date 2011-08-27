$test_env = true

require "./forms"

require 'nokogiri'

describe "the symbolize method" do
  it "should replace spaces with underscores" do
    symbolize("foo bar baz").should == :foo_bar_baz
  end
end
