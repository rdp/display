require 'redparse' # takes forever on doze [ltodo]

class Object
  def analyze *args
   a = caller
   last_caller = a[0] # "spec.analyze:9" # TODO work with full paths
   file, line, *rest = last_caller.split(":") # TODO cache shtuff
   exact_line = File.readlines(file)[line.to_i - 1].strip
   parser=RedParse.new(exact_line)
   tree = parser.parse
   out = nil
   # the trick is to break out with the first method call...
   right_call_node = give_me_first_call_node tree
   # eureka
   out = "#{file}:#{line} "
   right_call_node.params.each{ |p|
    out += "#{p.name}=#{args.shift}"
   }
   puts out
   out
  end
  
  def give_me_first_call_node tree
    tree.walk{|parent,i,subi,node|
      if node.class == RedParse::CallNode
        return tree
      else
        return give_me_first_call_node(node.right)
      end
    }
  end
  
end
