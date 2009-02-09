require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe DataMapper::Ambition::Query do
  before :all do
    class ::User
      include DataMapper::Resource

      property :id,    Serial
      property :name,  String
      property :admin, Boolean

      has n, :articles
    end

    class ::Article
      include DataMapper::Resource

      property :id,    Serial
      property :title, String

      belongs_to :user
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
        end
      end

      describe '=~' do
        before :all do
          @return = @subject.filter { |u| u.name =~ 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :like, @model.properties[:name], 'Dan Kubb' ] ]
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
          @return.conditions.should == [ [ :gt, @model.properties[:id], 1 ] ]
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
          @return.conditions.should == [ [ :gte, @model.properties[:id], 1 ] ]
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
          @return.conditions.should == [ [ :lt, @model.properties[:id], 1 ] ]
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
          @return.conditions.should == [ [ :lte, @model.properties[:id], 1 ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
          end
        end
      end

      [ :include?, :member?, :=== ].each do |method|
        describe "Range##{method}" do
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], 1..2 ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:id], nil ] ]
        end
      end

      describe 'receiver.has.attr == value' do
        before :all do
          @return = @subject.filter { |u| u.articles.title == 'DataMapper' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, Article.properties[:title], 'DataMapper' ] ]
        end

        it 'should set links' do
          @return.links.should == [ @model.relationships[:articles] ]
        end
      end

      describe 'receiver.belongs_to.attr == value' do
        before :all do
          model   = Article
          subject = DataMapper::Query.new(@repository, model)

          @return = subject.filter { |a| a.user.name == 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
        end

        it 'should set links' do
          @return.links.should == [ Article.relationships[:user] ]
        end
      end
    end

    describe 'with value' do
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], @name ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], $name ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:name], name ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], NAME ] ]
        end
      end

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
          @return.conditions.should == [ [ :eql, @model.properties[:name], nil ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:admin], true ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:admin], false ] ]
        end
      end

      describe 'Regexp' do
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
          @return.conditions.should == [ [ :like, @model.properties[:name], /Dan Kubb/ ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
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
          @return.conditions.sort_by { |c| c[1].name.to_s }.should == [
            [ :eql, @model.properties[:id],   1          ],
            [ :eql, @model.properties[:name], 'Dan Kubb' ],
          ]
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
          @return.conditions.should == [ [ :not, @model.properties[:id], 1 ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:id], 1 ] ]
        end
      end

      describe 'none' do
        before :all do
          @return = @subject.filter { |u| }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should return a copy of self' do
          @return.should eql(@subject)
        end

        it 'should not set conditions' do
          @return.conditions.should be_empty
        end
      end

      describe 'receiver matching a resource' do
        before :all do
          resource = User.new(:id => 1)

          @return = @subject.filter { |u| u == resource }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], 1 ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], 1 ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
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
            @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
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
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
        end
      end
    end
  end
end
