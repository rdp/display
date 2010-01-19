require 'rubygems'
require 'sane'
require_relative '../lib/show'
require 'spec/autorun'

describe "show off" do

  before do
    a = 3
    b=4
    @output = show a, b
  end

  it "should show the args" do
    assert @output.contain?( "a=")
    assert @output.contain?( "b=")
  end
  
  it "should have an [] style output" do
    assert @output =~ /\[.*\]/
  end
  
  it "should add spacing appropriately with commas" do
    assert @output.contain?(", ")
  end  
  
  it "should show linenumber too" do    
    assert @output.contain?(",11")
  end

  it "should retrieve call nodes for ya" do
    for string in ["c = show a, b", "show a, b"] do
      parser=RedParse.new(string)
      tree = parser.parse
      node = give_me_first_call_node tree
      assert node.class == RedParse::CallNode
      assert node.params.length == 2
    end
  end
  
  it "shouldn't barf with more complex things" do
    output = show 3, 4+5
  end
  
  it "should work with longer dir names in 1.8" do
    require 'sub/go2'
  end

  it "should cache lines instead of rereading the file every time"
  
  it "should use inspect" do
      a = [1,2,3]
      out = show a
      assert out.contain? "[1, 2, 3]"
      out = show [1,2,3]
      assert out.contain? "[1, 2, 3]"
  end
  
  it "should pretend to work in eval" do
    out = eval("show 1,2,3")
    assert(out.contain?('?='))
    assert(out.contain?('eval'))
    assert(out.contain?('1'))  
  end

end