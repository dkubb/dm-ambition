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
  end

  before :all do
    @repository = DataMapper.repository(:default)
    @model      = User
    @query      = DataMapper::Query.new(@repository, @model)
  end

  it { @query.should respond_to(:filter) }

  describe '#filter' do
    describe 'with operator' do
      describe '==' do
        before :all do
          @return = @query.filter { |u| u.name == 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
        end
      end

      describe '=~' do
        before :all do
          @return = @query.filter { |u| u.name =~ 'Dan Kubb' }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :like, @model.properties[:name], 'Dan Kubb' ] ]
        end
      end

      describe '>' do
        before :all do
          @return = @query.filter { |u| u.id > 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :gt, @model.properties[:id], 1 ] ]
        end
      end

      describe '>=' do
        before :all do
          @return = @query.filter { |u| u.id >= 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :gte, @model.properties[:id], 1 ] ]
        end
      end

      describe '<' do
        before :all do
          @return = @query.filter { |u| u.id < 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :lt, @model.properties[:id], 1 ] ]
        end
      end

      describe '<=' do
        before :all do
          @return = @query.filter { |u| u.id <= 1 }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :lte, @model.properties[:id], 1 ] ]
        end
      end

      describe 'Array#include?' do
        before :all do
          @return = @query.filter { |u| [ 1, 2 ].include?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Array#member?' do
        before :all do
          @return = @query.filter { |u| [ 1, 2 ].member?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Range#include?' do
        before :all do
          @return = @query.filter { |u| (1..2).include?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], 1..2 ] ]
        end
      end

      describe 'Range#member?' do
        before :all do
          @return = @query.filter { |u| (1..2).member?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], 1..2 ] ]
        end
      end

      describe 'Range#===' do
        before :all do
          @return = @query.filter { |u| (1..2) === u.id }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], 1..2 ] ]
        end
      end

      describe 'Hash#key?' do
        before :all do
          @return = @query.filter { |u| { 1 => '1', 2 => '2' }.key?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Hash#has_key?' do
        before :all do
          @return = @query.filter { |u| { 1 => '1', 2 => '2' }.has_key?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Hash#include?' do
        before :all do
          @return = @query.filter { |u| { 1 => '1', 2 => '2' }.include?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Hash#member?' do
        before :all do
          @return = @query.filter { |u| { 1 => '1', 2 => '2' }.member?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Hash#value?' do
        before :all do
          @return = @query.filter { |u| { '1' => 1, '2' => 2 }.value?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'Hash#has_value?' do
        before :all do
          @return = @query.filter { |u| { '1' => 1, '2' => 2 }.has_value?(u.id) }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:id], [ 1, 2 ] ] ]
        end
      end

      describe 'receiver.method.nil?' do
        it 'should be awesome'
      end
    end

    describe 'with value' do
      describe 'local variable' do
        before :all do
          name = 'Dan Kubb'

          @return = @query.filter { |u| u.name == name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:name], 'Dan Kubb' ] ]
        end
      end

      describe 'instance variable' do
        before :all do
          @name = 'Dan Kubb'

          @return = @query.filter { |u| u.name == @name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:name], @name ] ]
        end
      end

      describe 'global variable' do
        before :all do
          $name = 'Dan Kubb'

          @return = @query.filter { |u| u.name == $name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
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
          @return = @query.filter { |u| u.name == name }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          pending do
            @return.conditions.should == [ [ :eql, @model.properties[:name], name ] ]
          end
        end
      end

      describe 'constant' do
        NAME = 'Dan Kubb'

        before :all do
          @return = @query.filter { |u| u.name == NAME }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:name], NAME ] ]
        end
      end

      describe 'nil' do
        before :all do
          @return = @query.filter { |u| u.name == nil }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:name], nil ] ]
        end
      end

      describe 'true' do
        before :all do
          @return = @query.filter { |u| u.admin == true }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:admin], true ] ]
        end
      end

      describe 'false' do
        before :all do
          @return = @query.filter { |u| u.admin == false }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :eql, @model.properties[:admin], false ] ]
        end
      end

      describe 'Regexp' do
        before :all do
          @return = @query.filter { |u| u.name =~ /Dan Kubb/ }
        end

        it 'should return a Query' do
          @return.should be_kind_of(DataMapper::Query)
        end

        it 'should not return self' do
          @return.should_not == @query
        end

        it 'should set conditions' do
          @return.conditions.should == [ [ :like, @model.properties[:name], /Dan Kubb/ ] ]
        end
      end
    end

    describe 'with conditions' do
      describe 'ANDed' do
        it 'should be awesome'
      end

      describe 'negated' do
        it 'should be awesome'
      end

      describe 'double-negated' do
        it 'should be awesome'
      end

      describe 'none' do
        it 'should be awesome'
      end
    end
  end
end
