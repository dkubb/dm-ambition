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
    describe 'with operator' do
      describe '==' do
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

      describe '=~' do
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

      describe '>' do
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

      describe '>=' do
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

      describe '<' do
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

      describe '<=' do
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
        describe "Array##{method}" do
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
        describe "Range##{method} (inclusive)" do
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

        describe "Range##{method} (exclusive)" do
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
        describe "Hash##{method}" do
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
        describe "Hash##{method}" do
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

      describe 'receiver.method.nil?' do
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

    describe 'with bind value' do
      describe 'nil' do
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

      describe 'true' do
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

      describe 'false' do
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

    describe 'with conditions' do
      describe 'ANDed' do
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

      describe 'ORed' do
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

      describe 'negated' do
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

      describe 'double-negated' do
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
            DataMapper::Query::Conditions::Operation.new(:not,
              DataMapper::Query::Conditions::Operation.new(:not,
                DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:id], 1)
              )
            )
          )
        end
      end

      describe 'receiver matching a resource' do
        before :all do
          resource = User.create(:id => 1)

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
        describe "receiver matching a resource using Array##{method}" do
          before :all do
            resource = User.new(:id => 1)

            @return = @subject.filter { |u| [ resource ].send(method, u) }
          end

          it 'should return a Query' do
            @return.should be_kind_of(DataMapper::Query)
          end

          it 'should not return self' do
            @return.should_not equal(@subject)
          end

          it 'should set conditions' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:in, @model.properties[:id], [ 1 ])
            )
          end
        end
      end

      [ :key?, :has_key?, :include?, :member? ].each do |method|
        describe "receiver matching a resource using Hash##{method}" do
          before :all do
            one = User.new(:id => 1)
            two = User.new(:id => 2)

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
        describe "receiver matching a resource using Hash##{method}" do
          before :all do
            one = User.new(:id => 1)
            two = User.new(:id => 2)

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

      describe 'using send on receiver' do
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

    describe 'with external value' do
      describe 'local variable' do
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

      describe 'instance variable' do
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

      describe 'global variable' do
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

      describe 'method' do
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
          pending 'TODO: make methods work inside block' do
            @return.conditions.should == DataMapper::Query::Conditions::Operation.new(:and,
              DataMapper::Query::Conditions::Comparison.new(:eql, @model.properties[:name], name)
            )
          end
        end
      end

      describe 'constant' do
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

      describe 'namespaced constant' do
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

      describe 'namespaced method' do
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
  end
end
