require 'ruby_parser'
class Object
  def analyze *args
   opts = args[-1].is_a? Hash ? args.pop : {}
   _dbg
   a = caller
   last_caller = a[0] # "spec.analyze:9" # TODO work with full paths
   file, line, *rest = a.split(":") # TODO cache shtuff
   exact_line = File.readlines(file)[line.to_i].strip
   out = "#{file}:#{line} was #{exact_line}"
   if opts[:string]
    return out
   else
    puts out
   end
  end
end