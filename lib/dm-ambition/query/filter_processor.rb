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

        def initialize(binding, model, negated = false)
          super()

          self.expected        = Object # allow anything for now
          self.auto_shift_type = true
          self.default_method  = :process_error

          @binding    = binding
          @model      = model
          @receiver   = nil

          @conditions = @container = DataMapper::Query::Conditions::Operation.new(:and)

          if negated
            @conditions = DataMapper::Query::Conditions::Operation.new(:not, @container)
          end
        end

        def process_iter(exp)
          call_argslist = exp.shift

          # get the reciever
          @receiver = process(exp.shift)

          # process the Proc body
          process(exp.shift)
        end

        def process_lasgn(exp)
          exp.shift
        end

        def process_call(exp)
          lhs      = process(exp.shift)
          operator = exp.shift
          rhs      = process(exp.shift)

          return nil if lhs.nil?

          operator = rhs.shift if operator == :send

          evaluate_operator(operator, lhs, rhs.shift)
        end

        def process_and(exp)
          parent = @container

          begin
            unless @container.kind_of?(DataMapper::Query::Conditions::AndOperation)
              parent << @container = DataMapper::Query::Conditions::Operation.new(:and)
            end

            while sexp = exp.shift
              process(sexp)
            end
          ensure
            @container = parent
          end

          @container
        end

        def process_or(exp)
          parent = @container

          begin
            unless @container.kind_of?(DataMapper::Query::Conditions::OrOperation)
              parent << @container = DataMapper::Query::Conditions::Operation.new(:or)
            end

            while sexp = exp.shift
              process(sexp)
            end
          ensure
            @container = parent
          end

          @container
        end

        def process_not(exp)
          parent = @container

          begin
            parent << @container = DataMapper::Query::Conditions::Operation.new(:not)
            process(exp.shift)
          ensure
            @container = parent
          end

          @container
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
          literal = exp.shift
          exp.shift  # FIXME: workaround for bug in ParseTree or SexpProcessor
          literal
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
            elsif rhs.kind_of?(DataMapper::Resource) && operator == :==
              resource = rhs

              if resource.repository == DataMapper.repository && resource.saved?
                @model.key.zip(resource.key) do |property, bind_value|
                  @container << DataMapper::Query::Conditions::Comparison.new(:eql, property, bind_value)
                end

                @container
              end
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
            lhs.send(operator, *[ rhs ].compact)

          end
        end

        # TODO: update dm-core internals to use the Ruby operators
        # insted of the DM specific ones
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
      end # class FilterProcessor
    end # module Query
  end # module Ambition
end # module DataMapper
