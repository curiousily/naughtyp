require 'bitescript'

import java.lang.System
import java.io.InputStream
import java.io.PrintStream

module NaughtyP
  class Emitter
    include BiteScript

    def initialize(class_name)
      @file_builder = FileBuilder.build(__FILE__)
      @class = @file_builder.public_class(class_name)
      @class.start
      @method = @class.main
      @method.start
    end

    def read_int(store_index)
      @method.new java.util.Scanner
      @method.dup
      @method.getstatic System, :in, InputStream
      @method.invokespecial java.util.Scanner, "<init>", [@method.void, InputStream]
      @method.astore 2
      @method.aload 2
      @method.invokevirtual java.util.Scanner, "nextInt", @method.int
      @method.istore store_index
    end

    def print_read_int(load_index)
      @method.getstatic System, :out, PrintStream
      @method.iload load_index
      @method.invokevirtual PrintStream, "println", [@method.void, @method.int]
    end

    def print_int(store_index, number)
      create_local_variable(store_index, number)
      print_read_int(store_index)
    end

    def create_local_variable(store_index, value)
      @method.bipush value
      @method.istore store_index
    end

    def build
      @method.returnvoid
      @method.stop
      @class.stop
      @file_builder
    end
  end
end