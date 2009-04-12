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

        merge(:conditions => processor.conditions)
      end
    end # module Query
  end # module Ambition
end # module DataMapper

require Pathname(__FILE__).dirname.expand_path / 'query' / 'filter_processor'
