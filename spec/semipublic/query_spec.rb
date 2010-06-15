require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe DataMapper::Ambition::Query do
  before :all do
    class ::User
      include DataMapper::Resource

      property :id,    Serial
      property :name,  String
      property :admin, Boolean
    end

    class ::Person
      include DataMapper::Resource

      property :first_name, String, :key => true
      property :last_name,  String, :key => true
    end

    if DataMapper.respond_to?(:auto_migrate!)
      DataMapper.auto_migrate!
    end
  end

  before :all do
    @repository = DataMapper.repository(:default)
    @model      = User
    @query      = DataMapper::Query.new(@repository, @model)

    @subject = @query
  end

  it { @subject.should respond_to(:filter) }

  describe '#filter' do
    context 'with operator' do
      context '==' do
        before :all do
          @return = @subject.filter { |u| u.name == 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end

      context '=~' do
        before :all do
          @return = @subject.filter { |u| u.name =~ /Dan Kubb/ }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:regexp, @model.properties[:name], /Dan Kubb/)
          )
        end
      end

      context '>' do
        before :all do
          @return = @subject.filter { |u| u.id > 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:gt, @model.properties[:id], 1)
          )
        end
      end

      context '>=' do
        before :all do
          @return = @subject.filter { |u| u.id >= 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:gte, @model.properties[:id], 1)
          )
        end
      end

      context '<' do
        before :all do
          @return = @subject.filter { |u| u.id < 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:lt, @model.properties[:id], 1)
          )
        end
      end

      context '<=' do
        before :all do
          @return = @subject.filter { |u| u.id <= 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:lte, @model.properties[:id], 1)
          )
        end
      end

      [ :include?, :member? ].each do |method|
        context "Array##{method}" do
          before :all do
            @return = @subject.filter { |u| [ 1, 2 ].send(method, u.id) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1, 2 ])
            )
          end
        end
      end

      [ :include?, :member?, :=== ].each do |method|
        context "Range##{method} (inclusive)" do
          before :all do
            @return = @subject.filter { |u| (1..2).send(method, u.id) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], 1..2)
            )
          end
        end

        context "Range##{method} (exclusive)" do
          before :all do
            @return = @subject.filter { |u| (1...3).send(method, u.id) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], 1...3)
            )
          end
        end
      end

      [ :key?, :has_key?, :include?, :member? ].each do |method|
        context "Hash##{method}" do
          before :all do
            @return = @subject.filter { |u| { 1 => '1', 2 => '2' }.send(method, u.id) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1, 2 ])
            )
          end
        end
      end

      [ :value?, :has_value? ].each do |method|
        context "Hash##{method}" do
          before :all do
            @return = @subject.filter { |u| { '1' => 1, '2' => 2 }.value?(u.id) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1, 2 ])
            )
          end
        end
      end

      context 'receiver.method.nil?' do
        before :all do
          @return = @subject.filter { |u| u.id.nil? }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id], nil)
          )
        end
      end
    end

    context 'with bind value' do
      context 'nil' do
        before :all do
          @return = @subject.filter { |u| u.name == nil }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], nil)
          )
        end
      end

      context 'true' do
        before :all do
          @return = @subject.filter { |u| u.admin == true }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:admin], true)
          )
        end
      end

      context 'false' do
        before :all do
          @return = @subject.filter { |u| u.admin == false }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:admin], false)
          )
        end
      end
    end

    context 'with conditions' do
      context 'ANDed' do
        before :all do
          @return = @subject.filter { |u| u.id == 1 && u.name == 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id],   1),
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end

      context 'ORed' do
        before :all do
          @return = @subject.filter { |u| u.id == 1 || u.name == 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Operation.new(:or,
              DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id],   1),
              DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
            )
          )
        end
      end

      context 'negated' do
        before :all do
          @return = @subject.filter { |u| !(u.id == 1) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Operation.new(:not,
              DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id], 1)
            )
          )
        end
      end

      context 'double-negated' do
        before :all do
          @return = @subject.filter { |u| !(!(u.id == 1)) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id], 1)
          )
        end
      end

      context 'receiver matching a resource' do
        before :all do
          resource = @model.new(:id => 1)

          @return = @subject.filter { |u| u == resource }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id], 1)
          )
        end
      end

      [ :include?, :member? ].each do |method|
        context "receiver matching a resource using Array##{method}" do
          before :all do
            one = @model.new(:id => 1)
            two = @model.new(:id => 2)

            @return = @subject.filter { |u| [ one, two ].send(method, u) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1, 2 ])
            )
          end
        end

        context "receiver matching a resource (with a CPK) using Array##{method}" do
          before :all do
            @model   = Person
            @subject = DataMapper::Query.new(@repository, @model)

            @one = @model.new(:first_name => 'Dan',  :last_name => 'Kubb')
            @two = @model.new(:first_name => 'John', :last_name => 'Doe')

            @return = @subject.filter { |p| [ @one, @two ].send(method, p) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Operation.new(:or,
                DataMapper::Query::Conditions::Operation.new(:and,
                  DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:first_name], 'Dan'),
                  DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:last_name],  'Kubb')
                ),
                DataMapper::Query::Conditions::Operation.new(:and,
                  DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:first_name], 'John'),
                  DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:last_name],  'Doe')
                )
              )
            )
          end
        end
      end

      [ :key?, :has_key?, :include?, :member? ].each do |method|
        context "receiver matching a resource using Hash##{method}" do
          before :all do
            one = @model.new(:id => 1)
            two = @model.new(:id => 2)

            @return = @subject.filter { |u| { one => '1', two => '2' }.send(method, u) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1, 2 ])
            )
          end
        end
      end

      [ :value?, :has_value? ].each do |method|
        context "receiver matching a resource using Hash##{method}" do
          before :all do
            one = @model.new(:id => 1)
            two = @model.new(:id => 2)

            @return = @subject.filter { |u| { '1' => one, '2' => two }.send(method, u) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1, 2 ])
            )
          end
        end
      end

      context 'using send on receiver' do
        before :all do
          @return = @subject.filter { |u| u.send(:name) == 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end
    end

    context 'with external value' do
      context 'local variable' do
        before :all do
          name = 'Dan Kubb'

          @return = @subject.filter { |u| u.name == name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end

      context 'instance variable' do
        before :all do
          @name = 'Dan Kubb'

          @return = @subject.filter { |u| u.name == @name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], @name)
          )
        end
      end

      context 'global variable' do
        before :all do
          $name = 'Dan Kubb'

          @return = @subject.filter { |u| u.name == $name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], $name)
          )
        end
      end

      context 'method' do
        def name
          'Dan Kubb'
        end

        before :all do
          @return = @subject.filter { |u| u.name == name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end

      context 'method with arguments' do
        def name(first_name, last_name)
          "#{first_name} #{last_name}"
        end

        before :all do
          @return = @subject.filter { |u| u.name == name('Dan', 'Kubb') }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end

      context 'constant' do
        NAME = 'Dan Kubb'

        before :all do
          @return = @subject.filter { |u| u.name == NAME }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], NAME)
          )
        end
      end

      context 'namespaced constant' do
        before :all do
          Object.send(:remove_const, :Condition) if defined?(::Condition)
          module ::Condition
            Name = 'Dan Kubb'
          end

          @return = @subject.filter { |u| u.name == Condition::Name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end

      context 'namespaced method' do
        before :all do
          Object.send(:remove_const, :Condition) if defined?(::Condition)
          module ::Condition
            def self.name
              'Dan Kubb'
            end
          end

          @return = @subject.filter { |u| u.name == Condition::name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
            DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], 'Dan Kubb')
          )
        end
      end
    end

    context 'with an invalid block' do
      specify 'should raise an error' do
        expect {
          @subject.filter { |u| puts "Hello World"; u.id == 1 }
        }.to raise_error
      end
    end
  end
end
