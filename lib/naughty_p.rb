require "naughty_p/version"
require "naughty_p/token"
require "naughty_p/scanner"
require "naughty_p/parser"
require "naughty_p/emitter"
require "bitescript"
require "java"
require "jruby"

module NaughtyP

  def self.compile(file_name)
    parser = Parser.for_file(file_name)
    parser.eval_source
    file_builder = parser.build
    file_builder.generate do |filename, class_builder|
      File.open(filename, 'w') do |file|
        file.write(class_builder.generate)
      end
    end
  end

  def self.interpret(file_name)
    parser = Parser.for_file(file_name)
    parser.eval_source
    file_builder = parser.build
    loader = JRuby.runtime.jruby_class_loader
    file_builder.generate do |name, builder|
      bytes = builder.generate
      cls = loader.define_class(name[0..-7].gsub('/', '.'), bytes.to_java_bytes)
      JavaUtilities.get_proxy_class(cls.name).main([])
    end
  end
end
