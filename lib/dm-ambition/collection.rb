module DataMapper
  module Ambition
    module Collection
      def self.included(base)
        base.send(:alias_method, :find_all, :select)
        base.send(:alias_method, :find,     :detect)
      end

      # TODO: document this
      # @api public
      def select(&block)
        query = self.query.filter(&block)
        return new_collection(query, super) if loaded?

        collection = all(query)
        collection.unshift(*head.select(&block)) if head.any?
        collection.concat(tail.select(&block))   if tail.any?
        collection
      end

      # TODO: document this
      # @api public
      def detect(&block)
        return super if loaded?
        head.detect(&block) || first(query.filter(&block))
      end

      # TODO: document this
      # @api public
      def reject(&block)
        query = self.query.filter(true, &block)
        return new_collection(query, super) if loaded?

        collection = all(query)
        collection.unshift(*head.reject(&block)) if head.any?
        collection.concat(tail.reject(&block))   if tail.any?
        collection
      end
    end # module Collection
  end # module Ambition
end # module DataMapper
