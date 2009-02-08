# TODO: update Collection#select in dm-core to return a Collection
# TODO: update Collection#reject in dm-core to return a Collection

module DataMapper
  module Ambition
    module Collection
      def self.included(base)
        base.send(:alias_method, :find_all, :select)
        base.send(:alias_method, :find,     :detect)
      end

      # TODO: add empty?
      # TODO: add any?  (handle with and without block)
      # TODO: add all?  (handle with and without block)
      # TODO: add none? (handle with and without block) (add to LazyArray for < 1.9)
      # TODO: add one?  (handle with and without block) (add to LazyArray for < 1.9)

      # TODO: document this
      # @api public
      def select(&block)
        query = self.query.filter(&block)

        if loaded?
          new_collection(query, super)
        else
          collection = all(query)

          if head.any?
            collection.unshift(*head.select(&block))
          end

          if tail.any?
            collection.concat(tail.select(&block))
          end

          collection
        end
      end

      # TODO: document this
      # @api public
      def detect(&block)
        if loaded?
          super
        else
          head.detect(&block) || first(query.filter(&block))
        end
      end

      # TODO: document this
      # @api public
      def reject(&block)
        query = self.query.filter(true, &block)

        if loaded?
          new_collection(query, super)
        else
          collection = all(query)

          if head.any?
            collection.unshift(*head.reject(&block))
          end

          if tail.any?
            collection.concat(tail.reject(&block))
          end

          collection
        end
      end
    end # module Collection
  end # module Ambition
end # module DataMapper
