unless defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
  require 'parse_tree'
  require 'parse_tree_extensions'
end

require 'ruby2ruby'

module DataMapper
  module Ambition
    module Query
      class FilterProcessor < SexpProcessor
        attr_reader :conditions

        def initialize(binding, model)
          super()

          self.expected        = Object # allow anything for now
          self.auto_shift_type = true
          self.default_method  = :process_error

          @binding    = binding
          @model      = model
          @receiver   = nil

          @conditions = @container = DataMapper::Query::Conditions::Operation.new(:and)
        end

        def process_error(exp)
          raise "ERROR: calling process_#{exp.shift} with #{exp.inspect} (in process_error)"
        end

        def process_iter(exp)
          exp.shift

          # get the reciever
          @receiver = process(exp.shift)

          # process the Proc body
          process(exp.shift)
        end

        def process_call(exp)
          lhs      = process(exp.shift)
          operator = exp.shift
          rhs      = process(exp.shift)

          operator = rhs.shift if operator == :send

          if lhs.nil?
            call_method(operator, *rhs)
          else
            evaluate_operator(operator, lhs, rhs.shift)
          end
        end

        def process_and(exp)
          process_connective(exp, :and)
        end

        def process_or(exp)
          process_connective(exp, :or)
        end

        def process_not(exp)
          process_connective(exp, :not)
        end

        def process_lvar(exp)
          var = exp.shift
          var == @receiver ? @model : value(var)
        end

        def process_arglist(exp)
          process_array(exp)
        end

        def process_match3(exp)
          evaluate_operator(:=~, process(exp.shift), process(exp.shift))
        end

        def process_colon2(exp)
          process(exp.shift).const_get(exp.shift)
        end

        def process_const(exp)
          Object.const_get(exp.shift)
        end

        def process_lasgn(exp)
          exp.shift
        end

        def process_str(exp)
          exp.shift
        end

        def process_lit(exp)
          exp.shift
        end

        def process_ivar(exp)
          value(exp.shift)
        end

        def process_gvar(exp)
          value(exp.shift)
        end

        def process_true(exp)
          true
        end

        def process_false(exp)
          false
        end

        def process_nil(exp)
          nil
        end

        def process_array(exp)
          array = []
          array << process(exp.shift) until exp.empty?
          array
        end

        def process_hash(exp)
          hash = {}
          hash[process(exp.shift)] = process(exp.shift) until exp.empty?
          hash
        end

      private

        def process_connective(exp, operation)
          parent, @container = @container, DataMapper::Query::Conditions::Operation.new(operation)
          process(exp.shift) until exp.empty?
          parent << @container
        ensure
          @container = parent
        end

        def evaluate_operator(operator, lhs, rhs)
          if lhs == @model
            if rhs.nil?
              @model.properties[operator]
            elsif rhs.kind_of?(DataMapper::Resource) && operator == :==
              key = @model.key
              @container << DataMapper::Query.target_conditions(rhs, key, key)
            end

          elsif rhs == @model
            resources = case lhs
              when Array
                case operator
                  when :include?, :member? then lhs
                end

              when Hash
                case operator
                  when :key?, :has_key?, :include?, :member? then lhs.keys
                  when :value?, :has_value?                  then lhs.values
                end
            end

            key = @model.key
            @container << DataMapper::Query.target_conditions(resources, key, key)

          elsif lhs.kind_of?(DataMapper::Property)
            property   = lhs
            bind_value = rhs

            # TODO: throw an exception if the operator is :== and the value is an Array
            #   - this prevents conditions like { |u| u.val == [ 1, 2, 3 ] }

            if operator == :nil? && bind_value.nil?
              operator   = :==
              bind_value = nil
            end

            operator = remap_operator(operator)

            @container << DataMapper::Query::Conditions::Comparison.new(operator, property, bind_value)

          elsif rhs.kind_of?(DataMapper::Property)
            property   = rhs
            bind_value = lhs

            # TODO: throw an exception if the operator is :== and the bind value is an Array
            #   - this prevents conditions like { |u| [ 1, 2, 3 ] == u.val }

            case bind_value
              when Array
                case operator
                  when :include?, :member?
                    operator = :in
                end

              when Range
                case operator
                  when :include?, :member?, :===
                    operator = :in
                end

              when Hash
                case operator
                  when :key?, :has_key?, :include?, :member?
                    operator   = :in
                    bind_value = bind_value.keys
                  when :value?, :has_value?
                    operator   = :in
                    bind_value = bind_value.values
                end
            end

            operator = remap_operator(operator)

            @container << DataMapper::Query::Conditions::Comparison.new(operator, property, bind_value)

          elsif lhs.respond_to?(operator)
            lhs.send(operator, *Array(rhs))

          end
        end

        def remap_operator(operator)
          # remap Ruby to DM operators
          case operator
            when :in then :in
            when :== then :eql
            when :=~ then :regexp
            when :>  then :gt
            when :>= then :gte
            when :<  then :lt
            when :<= then :lte
          end
        end

        def value(value)
          eval(value.to_s, @binding)
        end

        def call_method(name, *args)
          value("method(#{name.inspect})").call(*args)
        end
      end # class FilterProcessor
    end # module Query
  end # module Ambition
end # module DataMapper
