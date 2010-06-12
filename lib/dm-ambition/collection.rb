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
