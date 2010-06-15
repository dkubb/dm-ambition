module DataMapper
  module Ambition
    module Collection
      def self.included(base)
        base.send(:alias_method, :find,     :detect)
        base.send(:alias_method, :find_all, :select)
      end

      # TODO: document this
      # @api public
      def detect(&block)
        return super if loaded?
        head.detect(&block) || first(query.filter(&block))
      end

      # TODO: document this
      # @api public
      def select(&block)
        filter_collection(:&, block) { super }
      end

      # TODO: document this
      # @api public
      def reject(&block)
        filter_collection(:-, block) { super }
      end

    private

      # @api private
      def filter_collection(operation, block)
        query = self.query.filter(&block)
        return new_collection(query, yield) if loaded?

        collection = self.send(operation, all(query))
        collection.unshift(*head.send(operation, head.select(&block))) if head.any?
        collection.concat(tail.send(operation, tail.select(&block)))   if tail.any?
        collection
      end

    end # module Collection
  end # module Ambition
end # module DataMapper
