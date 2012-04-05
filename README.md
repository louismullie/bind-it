**About**
  
BindIt is a very simple tool to facilitate the creation of Java bindings in Ruby. It provides a simplified interface to load JARs and Java classes, and allows logging of JVM output to a text file. It also enhances the Rjb Java proxy with useful functions, such as internal iterators.

BindIt uses the Ruby-Java-Bridge (Rjb) to access Java objects. It runs on Ruby 1.9.2 and 1.9.3.

**Installing**

`gem install bind-it`

**Usage**

1. Create a module into which Java classes will be loaded.
2. Make sure that module extends `BindIt::Binding`.
3. Set some configuration options (see example below).
4. Run YourModule.bind to load the default JARs and classes.
5. Access loaded Java classes using YourModule::YourClass.

**Example**

```ruby

require 'bind-it'

module MyBindings 

  extend BindIt::Binding

  # The path in which to look for JAR files.
  self.jar_path = '/path/to/jars/'

  # Arguments to use when initializing the JVM.
  self.jvm_args = ['-option1X', '-option2X']

  # If set, JVM output is redirected to file.
  self.log_file = 'log_file.txt'

  # Default JAR files to load.
  self.default_jars = [
    'jar1.jar',
    'jar2.jar'
  ]

  # Default classes to load under MyBindings.
  # Shown are the three different ways of adding
  # a class to the default list.
  self.default_classes = [
     # Will search for class in default_namespace.
     ['MyClass'],
     # Supply a non-default namespace.
     ['MyClass', 'path.to.namespace'],
     # Rename the Java class in Ruby.
     ['MyClass', 'path.to.namespace', 'MyClass2']
  ]

  # Default namespace to use.
  self.default_namespace = 'edu.stanford.nlp.pipeline'

  # Load the default JARs and classes.
  self.bind

end



obj = MyBindings::MyClass.new

```

**Contributing**

Feel free to fork the project and send me a pull request!