module DataMapper
  module Ambition
    module Query

      # TODO: spec and document this
      # @api semipublic
      def filter(&block)
        processor = FilterProcessor.new(block.binding, model)
        processor.process(sexp_for(block))
        self.class.new(repository, model, options.merge(:conditions => conditions & processor.conditions))
      end

    private

      if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
        # do not deep clone sexp
        def sexp_for(block)
          block.to_sexp
        end
      else
        @@sexps = {}

        # deep clone the sexp for multiple re-use
        def sexp_for(block)
          Marshal.load(@@sexps[block.to_s] ||= Marshal.dump(block.to_sexp))
        end
      end

    end # module Query
  end # module Ambition
end # module DataMapper
