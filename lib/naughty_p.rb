require "naughty_p/version"
require "naughty_p/token"
require "naughty_p/scanner"
require "naughty_p/parser"
require "naughty_p/emitter"

module NaughtyP

  def self.compile(source_code, file_name)
    class_name = file_name.chomp(File.extname(file_name))
    parser = Parser.new(source_code, class_name)
    parser.eval_source
    parser.build
  end
end
