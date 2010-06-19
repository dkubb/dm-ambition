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
        new_query = query.filter(&block)
        return new_collection(new_query, yield) if loaded?

        collection = send(operation, all(new_query))
        collection.unshift(*head.send(operation, head.select(&block)))
        collection.concat(tail.send(operation, tail.select(&block)))
        collection
      end

    end # module Collection
  end # module Ambition
end # module DataMapper
