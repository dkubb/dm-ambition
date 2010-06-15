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

          @binding = binding
          @model   = model

          @conditions = @container = DataMapper::Query::Conditions::Operation.new(:and)
        end

        def process_error(exp)
          raise "ERROR: calling process_#{exp.shift} with #{exp.inspect} (in process_error)"
        end

        def process_iter(exp)
          exp.shift
          @receiver = process(exp.shift)
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
          lvar = exp.shift
          lvar.equal?(@receiver) ? @receiver : eval(lvar)
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
          eval(exp.shift)
        end

        def process_gvar(exp)
          eval(exp.shift)
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
          if    lhs.equal?(@receiver)              then evaluate_receiver_source(operator, lhs, rhs)
          elsif rhs.equal?(@receiver)              then evaluate_receiver_target(operator, lhs, rhs)
          elsif lhs.kind_of?(DataMapper::Property) then evaluate_property_source(operator, lhs, rhs)
          elsif rhs.kind_of?(DataMapper::Property) then evaluate_property_target(operator, lhs, rhs)
          else
            lhs.send(operator, *Array(rhs))
          end
        end

        def evaluate_receiver_source(operator, lhs, rhs)
          if rhs.nil?
            @model.properties[operator]
          elsif rhs.kind_of?(DataMapper::Resource) && operator == :==
            key = @model.key
            @container << DataMapper::Query.target_conditions(rhs, key, key)
          else
            raise 'TODO: spec this branch'
          end
        end

        def evaluate_receiver_target(operator, lhs, rhs)
          resources = case lhs
            when Hash
              case operator
                when :key?, :has_key?, :include?, :member? then lhs.keys
                when :value?, :has_value?                  then lhs.values
              end
            when Enumerable
              case operator
                when :include?, :member? then lhs
              end
            else
              raise 'TODO: spec this branch'
          end

          key = @model.key
          @container << DataMapper::Query.target_conditions(resources, key, key)
        end

        def evaluate_property_source(operator, lhs, rhs)
          bind_value = rhs

          operator = if operator == :nil?
            :eql
          else
            remap_operator(operator)
          end

          @container << DataMapper::Query::Conditions::Comparison.new(operator, lhs, bind_value)
        end

        def evaluate_property_target(operator, lhs, rhs)
          bind_value = lhs

          operator = case bind_value
            when Hash
              case operator
                when :key?, :has_key?, :include?, :member?
                  bind_value = bind_value.keys
                  :in
                when :value?, :has_value?
                  bind_value = bind_value.values
                  :in
              end
            when Range
              case operator
                when :include?, :member?, :===
                  :in
              end
            when Enumerable
              case operator
                when :include?, :member?
                  :in
              end
            else
              remap_operator(operator)
          end

          @container << DataMapper::Query::Conditions::Comparison.new(operator, rhs, bind_value)
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

        def eval(value, binding = @binding)
          super(value.to_s, binding)
        end

        def call_method(name, *args)
          eval("method(#{name.inspect})").call(*args)
        end
      end # class FilterProcessor
    end # module Query
  end # module Ambition
end # module DataMapper
