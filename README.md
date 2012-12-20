**About**
  
BindIt is a tool that allows to build platform-agnostic Ruby wrappers for JAVA code. The resulting bindings will work both on the JRuby and MRI platforms. On the MRI platform, BindIt uses the Ruby-Java-Bridge (Rjb) to access Java objects. 

BindIt is tested on MRI Ruby 1.9.2 and 1.9.3, as well as JRuby 1.6.7.2 and 1.7.1.

**Installing**

`gem install bind-it`

**Usage**

1. Create a module into which Java classes will be loaded.
2. Make sure that module extends `BindIt::Binding`.
3. Set your configuration options (see examples below).
4. Run YourModule.bind to load the default JARs and classes.
5. Access loaded Java classes using YourModule::YourClass.

**Example**

```ruby

require 'bind-it'

module MyBindings 

  extend BindIt::Binding

  # Arguments to use when initializing the JVM.
  self.jvm_args = ['-option1X', '-option2X']

  # If set, JVM output is redirected to file.
  self.log_file = 'log_file.txt'

  # The path in which to look for JAR files.
  self.jar_path = '/path/to/jars/'

  # Default JAR files to load.
  self.default_jars = [
    'jar1.jar',
    'jar2.jar'
  ]

  # Default namespace to use when loading classes.
  self.default_namespace = 'path.to.default'

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

  # Load the default JARs and classes.
  self.bind

end

obj = MyBindings::MyClass.new

```

**Contributing**

Feel free to fork the project and send me a pull request!