module DataMapper
  module Ambition
    module Model
      def self.included(base)
        base.send(:alias_method, :find_all, :select)
        base.send(:alias_method, :find,     :detect)
      end

      # TODO: document this
      # @api public
      def select(&block)
        all.select(&block)
      end

      # TODO: document this
      # @api public
      def detect(&block)
        all.detect(&block)
      end

      # TODO: document this
      # @api public
      def reject(&block)
        all.reject(&block)
      end

    end # module Model
  end # module Ambition
end # module DataMapper
