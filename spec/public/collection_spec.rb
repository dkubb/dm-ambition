require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

[ false, true ].each do |loaded|
  describe DataMapper::Ambition::Collection do
    class << self
      attr_accessor :loaded
    end

    self.loaded = loaded

    before :all do
      class ::User
        include DataMapper::Resource

        property :id,    Serial
        property :name,  String
        property :admin, Boolean, :default => false
      end

      @model = User
    end

    supported_by :all do
      before :all do
        @query = DataMapper::Query.new(@repository, @model)

        @user  = @model.create(:name => 'Dan Kubb', :admin => true)
        @other = @model.create(:name => 'Sam Smoot')

        @subject = @model.all(@query)
        @subject.to_a if loaded
      end

      it_should_behave_like 'it has public filter methods'

      unless loaded
        [ :select, :find_all ].each do |method|
          describe "##{method}", '(unloaded)' do
            describe 'when matching resource prepended' do
              before :all do
                @subject.unshift(@other)
                @return = @subject.send(method) { |u| u.admin == true }
              end

              it 'should return a Collection' do
                @return.should be_kind_of(DataMapper::Collection)
              end

              it 'should not return self' do
                @return.should_not equal(@subject)
              end

              it 'should not be a kicker' do
                @return.should_not be_loaded
              end

              it 'should return expected values' do
                @return.should == [ @user ]
              end

              it "should return the same as Array##{method}" do
                @return.should == @subject.to_a.send(method) { |u| u.admin == true }
              end
            end

            describe 'when matching resource appended' do
              before :all do
                @subject << @other
                @return = @subject.send(method) { |u| u.admin == true }
              end

              it 'should return a Collection' do
                @return.should be_kind_of(DataMapper::Collection)
              end

              it 'should not return self' do
                @return.should_not equal(@subject)
              end

              it 'should not be a kicker' do
                @return.should_not be_loaded
              end

              it 'should return expected values' do
                @return.should == [ @user ]
              end

              it "should return the same as Array##{method}" do
                @return.should == @subject.to_a.send(method) { |u| u.admin == true }
              end
            end
          end
        end

        describe '#reject', '(unloaded)' do
          describe 'when matching resource prepended' do
            before :all do
              @subject.unshift(@other)
              @return = @subject.reject { |u| u.admin != true }
            end

            it 'should return a Collection' do
              @return.should be_kind_of(DataMapper::Collection)
            end

            it 'should not return self' do
              @return.should_not equal(@subject)
            end

            it 'should not be a kicker' do
              @return.should_not be_loaded
            end

            it 'should return expected values' do
              @return.should == [ @user ]
            end

            it 'should return the same as Array#reject' do
              @return.should == @subject.to_a.reject { |u| u.admin != true }
            end
          end

          describe 'when matching resource appended' do
            before :all do
              @subject << @other
              @return = @subject.reject { |u| u.admin != true }
            end

            it 'should return a Collection' do
              @return.should be_kind_of(DataMapper::Collection)
            end

            it 'should not return self' do
              @return.should_not equal(@subject)
            end

            it 'should not be a kicker' do
              @return.should_not be_loaded
            end

            it 'should return expected values' do
              @return.should == [ @user ]
            end

            it 'should return the same as Array#reject' do
              @return.should == @subject.to_a.reject { |u| u.admin != true }
            end
          end
        end
      end
    end
  end
end
