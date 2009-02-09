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
          raise "DEBUG: calling process_#{exp.shift} with #{exp.inspect} (in process_error)"
        end

        def process_iter(exp)
          call_argslist = exp.shift
          raise "DEBUG: invalid: #{call_argslist.inspct}" if call_argslist != s(:call, nil, :proc, s(:arglist))

          # get the reciever
          @receiver = process(exp.shift)

          # process the Proc body
          result = process(exp.shift)

          unless result.equal?(@conditions) || (result.nil? && @conditions.empty?)
            raise "DEBUG: invalid result processing body: #{result.inspect}"
          end

          result
        end

        def process_lasgn(exp)
          exp.shift
        end

        def process_call(exp)
          if exp.size == 3
            lhs      = process(exp.shift)
            operator = exp.shift
            rhs      = process(exp.shift)

            if operator == :send
              operator = rhs.shift
            end

            if rhs.size > 1
              raise "DEBUG: rhs.size should not be larger than 1, but was #{rhs.size}: #{rhs.inspect}"
            else
              rhs = rhs.first
            end

            if lhs.nil?
              nil
            else
              evaluate_operator(operator, lhs, rhs)
            end
          else
            raise "DEBUG: unhandled call: #{exp.inspect}"
          end
        end

        def process_and(exp)
          while sexp = exp.shift
            process(sexp)
          end
          @conditions
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

          evaluate_operator(:=~, lhs, rhs)
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

        def evaluate_operator(operator, lhs, rhs)
          if lhs == @model
            if rhs.nil?
              @model.properties[operator]
            elsif rhs.kind_of?(DataMapper::Resource)
              resource = rhs

              if (key = resource.key).all?
                @conditions.update(@model.key.zip(key).to_hash)
              end
            else
              raise "DEBUG: cannot call #{@model.name}##{operator} with #{rhs.inspect}"
            end

          elsif rhs == @model
            if @model.key.size > 1
              raise 'Until OR conditions are added can only match resources with single keys'
            end

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

            unless resources
              raise "DEBUG: cannot call #{lhs.class}##{operator} with #{rhs.inspect}"
            end

            unless resources.all? { |r| r.kind_of?(DataMapper::Resource) }
              raise 'cannot compare against a non-resource'
            end

            property   = @model.key.first
            bind_value = resources.map { |r| r.key.first }.sort

            evaluate_operator(:include?, bind_value, property)

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

            @conditions.update(DataMapper::Query::Operator.new(property.name, operator) => bind_value)

          elsif rhs.kind_of?(DataMapper::Property)
            property   = rhs
            bind_value = lhs

            # TODO: throw an exception if the operator is :== and the bind value is an Array
            #   - this prevents conditions like { |u| [ 1, 2, 3 ] == u.val }

            case bind_value
              when Array
                case operator
                  when :include?, :member?
                    operator = :==
                  else
                    raise "DEBUG: cannot call Array##{operator} with #{bind_value.inspect}"
                end

              when Range
                case operator
                  when :include?, :member?, :===
                    operator = :==
                  else
                    raise "DEBUG: cannot call Range##{operator} with #{bind_value.inspect}"
                end

              when Hash
                case operator
                  when :key?, :has_key?, :include?, :member?
                    operator   = :==
                    bind_value = bind_value.keys
                  when :value?, :has_value?
                    operator   = :==
                    bind_value = bind_value.values
                  else
                    raise "DEBUG: cannot call Hash##{operator} with #{bind_value.inspect}"
                end
            end

            operator = remap_operator(operator)

            @conditions.update(DataMapper::Query::Operator.new(property.name, operator) => bind_value)

          elsif lhs.respond_to?(operator)
            lhs.send(operator, *[ rhs ].compact)

          else
            raise "DEBUG: not handled: #{lhs.inspect} #{operator} #{rhs.inspect}"

          end
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
            else raise "DEBUG: unknown operator #{operator}"
          end
        end

        def value(value)
          eval(value.to_s, @binding)
        end
      end # class FilterProcessor
    end # module Query
  end # module Ambition
end # module DataMapper
