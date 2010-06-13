require 'dm-ambition/query/filter_processor'

module DataMapper
  module Ambition
    module Query
      @@sexps = {}

      # TODO: spec and document this
      # @api semipublic
      def filter(negated = false, &block)
        # TODO: benchmark Marshal versus just building the sexp on demand

        # deep clone the sexp for multiple re-use
        sexp = Marshal.load(@@sexps[block.to_s] ||= Marshal.dump(block.to_sexp))

        processor = FilterProcessor.new(block.binding, model, negated)
        processor.process(sexp)

        self.class.new(repository, model, options.merge(:conditions => conditions & processor.conditions))
      end
    end # module Query
  end # module Ambition
end # module DataMapper
