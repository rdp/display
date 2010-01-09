require 'sane'
require_rel '../lib/analyze'
require 'spec/autorun'

describe "analyze" do

  it "should be callable" do
    a = b = 3
    c = analyze a, b
    assert c.contain?( "a=")
    assert c.contain?( "b=")
  end
  
  it "should add spacing appropriately with commas" do
    a = b = 3
    c = analyze a, b
    assert c.contain?(",")
  end  
  
  it "should get all variables"
  it "should show linenumber too"

  it "should retrieve call nodes for ya" do
   for string in ["c = analyze a, b", "analyze a, b"] do
     parser=RedParse.new(string)
     tree = parser.parse
     node = give_me_first_call_node tree
     assert node.class == RedParse::CallNode
     assert node.params.length == 2
   end
  end

end