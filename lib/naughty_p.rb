require "naughty_p/version"
require "naughty_p/token"
require "naughty_p/lexer"
require "naughty_p/parser"
require 'bitescript'

include BiteScript

module NaughtyP
  def compile(source_file)
    class_name = source_file.chomp(File.extname(source_file) )
    file_builder = FileBuilder.build(__FILE__) do
      public_class "#{class_name}" do
        public_static_method "main", [], void, string[] do
          aload 0
          push_int 0
          aaload
          label :top
          dup
          aprintln
          goto :top
          returnvoid
        end
      end
    end

    file_builder.generate do |filename, class_builder|
      File.open(filename, 'w') do |file|
        file.write(class_builder.generate)
      end
    end
  end
end
