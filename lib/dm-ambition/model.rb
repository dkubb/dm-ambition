module DataMapper
  module Ambition
    module Model
      # TODO: spec and document this
      # @api public
      def select(&block)
        all.select(&block)
      end

      alias find_all select

      # TODO: spec and document this
      # @api public
      def detect(&block)
        all.detect(&block)
      end

      alias find detect

      # TODO: spec and document this
      # @api public
      def reject(&block)
        all.reject(&block)
      end
    end # module Model
  end # module Ambition
end # module DataMapper
