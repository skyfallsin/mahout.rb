raise "JRuby required to run this" unless RUBY_PLATFORM =~ /java/

Dir[File.join(File.dirname(__FILE__), "lib", "*.jar")].each {|jar_file| 
  require jar_file 
}
