require 'stringio' # fix a sequence 0.4.0 bug
require 'redparse'

class Object
  def show *args
   a = caller
   last_caller = a[0] 
   if last_caller[1..1] == ":"
     # might be like E:/dev/ruby/sane/spec/../lib/sane/require_relative.rb:9:in `require_relative'
     drive, file, line, *rest = last_caller.split(":")
   else
     # or like
     # "spec.analyze:9"
     file, line, *rest = last_caller.split(":")
   end
   
   if(file.include?('eval')) 
     out = '[eval] '
     names = args.map{|a| '?'}
   else 
     exact_line = File.readlines(file)[line.to_i - 1].strip
     parser = RedParse.new(exact_line)
     tree = parser.parse
     # the trick is to break out with the first method call...
     right_call_node = give_me_first_call_node tree
     names = right_call_node.params.map{|p| p.unparse}
     out = "[#{File.basename(file)},#{line}] "
   end
   
   
   args2 = names.map{ |n|
      "#{n}=#{args.shift.inspect}"
   }.join(', ')
   
   out += args2   
   puts out
   out
  end
  
  def give_me_first_call_node tree
    tree.walk{|parent,i,subi,node|
      if node.class == RedParse::CallNode
       # eureka
        return tree
      else
        return give_me_first_call_node(node.right)
      end
    }
  end
  
end
