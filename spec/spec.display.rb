require 'sane'
require_rel '../lib/display'
require 'spec/autorun'

describe "display" do

  before do
    a = 3
    b=4
    @output = display a, b
  end

  it "should be callable" do
    assert @output.contain?( "a=")
    assert @output.contain?( "b=")
  end
  
  it "should add spacing appropriately with commas" do
    assert @output.contain?(", ")
  end  
  
  it "should show linenumber too" do
    assert @output.contain?(",10")
  end

  it "should retrieve call nodes for ya" do
    for string in ["c = display a, b", "display a, b"] do
      parser=RedParse.new(string)
      tree = parser.parse
      node = give_me_first_call_node tree
      assert node.class == RedParse::CallNode
      assert node.params.length == 2
    end
  end
  
  it "shouldn't barf with more complex things" do
    output = display 3, 4+5
  end

end