require 'rubygems'

gem 'ParseTree', '~>3.0.3'
require 'parse_tree'
require 'parse_tree_extensions'

gem 'ruby2ruby', '~>1.2.2'
require 'ruby2ruby'

module DataMapper
  module Ambition
    module Query
      class FilterProcessor < SexpProcessor
        attr_reader :conditions

        def initialize(binding, model, negated = false)
          super()

          self.expected        = Object # allow anything for now
          self.auto_shift_type = true
          self.default_method  = :process_error

          @binding    = binding
          @model      = model
          @receiver   = nil
          @conditions = {}
          @negated    = negated
        end

        def process_error(exp)
          raise "ERROR: calling process_#{exp.shift} with #{exp.inspect} (in process_error)"
        end

        def process_iter(exp)
          call_argslist = exp.shift
          raise "DEBUG: invalid: #{call_argslist.inspct}" if call_argslist != s(:call, nil, :proc, s(:arglist))

          # process the reciever
          @receiver = process(exp.shift)

          # process the body
          process(exp.shift)
        end

        def process_lasgn(exp)
          exp.shift
        end

        def process_call(exp)
          if exp.size == 3
            lhs      = process(exp.shift)
            operator = exp.shift
            rhs      = process(exp.shift)

            if lhs.nil?
              nil
            else
              process_operator(operator, lhs, rhs)
            end
          else
            raise "unhandled call: #{exp.inspect}"
          end
        end

        def process_and(exp)
          while sexp = exp.shift
            process(sexp)
          end
        end

        def process_not(exp)
          @negated = !@negated
          process(exp.shift)
        ensure
          @negated = !@negated
        end

        def process_lvar(exp)
          var = exp.shift
          var == @receiver ? @model : value(var)
        end

        def process_arglist(exp)
          arglist = []
          while sexp = exp.shift
            arglist << process(sexp)
          end
          arglist
        end

        def process_operator(operator, lhs, rhs)
          if lhs == @model && rhs.empty?
            @model.properties[operator]
          elsif rhs.respond_to?(:size) && rhs.size == 1 && rhs.first.kind_of?(DataMapper::Property)
            rhs = rhs.first

            # TODO: throw an exception if the operator is :== and the value is an Array
            #   - this prevents conditions like { |u| u.val == [ 1, 2, 3 ] }

            case lhs
              when Array
                case operator
                  when :include?, :member?
                    operator = :==
                end

              when Range
                case operator
                  when :include?, :member?, :===
                    operator = :==
                end

              when Hash
                case operator
                  when :key?, :has_key?, :include?, :member?
                    operator = :==
                    lhs      = lhs.keys
                  when :value?, :has_value?
                    operator = :==
                    lhs      = lhs.values
                end
            end

            operator = remap_operator(operator)

            @conditions.update(DataMapper::Query::Operator.new(rhs.name, operator) => lhs)
          elsif lhs.kind_of?(DataMapper::Property)
            # TODO: throw an exception if the operator is :== and the value is an Array
            #   - this prevents conditions like { |u| u.val == [ 1, 2, 3 ] }

            if operator == :nil? && rhs.empty?
              operator = :==
              rhs      = nil
            end

            operator = remap_operator(operator)

            @conditions.update(DataMapper::Query::Operator.new(lhs.name, operator) => rhs)
          elsif lhs.respond_to?(operator)
            lhs.send(operator, *rhs)
          else
            raise "NOT HANDLED: #{lhs.inspect} #{operator.inspect} #{rhs.inspect}"
          end
        end

        def process_colon2(exp)
          const = process(exp.shift)

          const.const_get(exp.shift)
        end

        def process_const(exp)
          Object.const_get(exp.shift)
        end

        def process_match3(exp)
          rhs = process(exp.shift)
          lhs = process(exp.shift)

          process_operator(:=~, lhs, rhs)
        end

        def process_array(exp)
          array = []
          while sexp = exp.shift
            array << process(sexp)
          end
          array
        end

        def process_hash(exp)
          hash = {}
          until exp.empty?
            key   = process(exp.shift)
            value = process(exp.shift)

            hash[key] = value
          end
          hash
        end

        def process_str(exp)
          exp.shift
        end

        def process_lit(exp)
          exp.shift
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

        def process_ivar(exp)
          value(exp.shift)
        end

        def process_gvar(exp)
          value(exp.shift)
        end

        def remap_operator(operator)
          # remap Ruby to DM operators
          case operator
            when :== then @negated ? :not : :eql
            when :=~ then @negated ? raise('cannot do negated regexp match yet') : :like
            when :>  then @negated ? :lte : :gt
            when :>= then @negated ? :lt  : :gte
            when :<  then @negated ? :gte : :lt
            when :<= then @negated ? :gt  : :lte
            else raise "unknown operator #{operator}"
          end
        end

        def value(value)
          eval(value.to_s, @binding)
        end
      end # class FilterProcessor
    end # module Query
  end # module Ambition
end # module DataMapper
