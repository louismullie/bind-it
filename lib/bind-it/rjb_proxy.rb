module BindIt::RjbProxy

  # Modify the Rjb JavaProxy class to add our own 
  # methods to every proxied Java object.
  Rjb::Rjb_JavaProxy.class_eval do

    # Dynamically defined on all proxied Java objects.
    # Shorthand for toString() defined by Java classes.
    def to_s; to_string; end
    
    # Dynamically defined on all proxied Java objects.
    # Shorthand for toArray() defined by Java classes.
    def to_a; to_array; end
    
    # Dynamically defined on all proxied Java iterators.
    # Provide Ruby-style iterators to wrap Java iterators.
    def each
      if !java_methods.include?('iterator()')
        raise 'This object cannot be iterated.'
      else
        i = self.iterator
        while i.has_next; yield i.next; end
      end
    end
    
    alias :old_method_missing :method_missing
    
    # Bug fix for Rjb, which sometimes fails to 
    # un-camel-case methods in the method_missing handler.
    def method_missing(sym, *args, &block)
      if [:to_int, :to_hash, :to_path, :to_str, :to_ary].include?(sym)
        super(sym, *args, &block)
      end
      sym = sym.to_s.gsub(/^[a-z]|_[a-z]/) do |a|
        a.upcase
      end.gsub('_', '').tap { |s| s[0] = s[0].downcase }
      old_method_missing(sym.intern,*args,&block)
    end
    
  end

end