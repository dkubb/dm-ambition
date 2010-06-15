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
        filter_collection(:select, block) { super }
      end

      # TODO: document this
      # @api public
      def reject(&block)
        filter_collection(:reject, block, true) { super }
      end

    private

      # @api private
      def filter_collection(method, block, negate = false)
        query = self.query.filter(negate, &block)
        return new_collection(query, yield) if loaded?

        collection = all(query)
        collection.unshift(*head.send(method, &block)) if head.any?
        collection.concat(tail.send(method, &block))   if tail.any?
        collection
      end

    end # module Collection
  end # module Ambition
end # module DataMapper
