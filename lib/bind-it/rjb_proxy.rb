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
    
  end

end
