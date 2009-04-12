share_examples_for 'it has public filter methods' do
  [ :select, :find_all ].each do |method|
    it { @subject.should respond_to(method) }

    describe "##{method}", ('(loaded)' if loaded) do
      describe 'with simple conditions' do
        before :all do
          @return = @subject.send(method) { |u| u.name == 'Dan Kubb' }
        end

        it 'should return a Collection' do
          @return.should be_kind_of(DataMapper::Collection)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        unless loaded
          it 'should not be a kicker' do
            @subject.respond_to?(:loaded) and @subject.should_not be_loaded
          end
        end

        it 'should return expected values' do
          @return.should == [ @user ]
        end
      end

      describe 'with OR + AND conditions' do
        before :all do
          @return = @subject.send(method) { |u| (u.name == 'Dan Kubb' || u.name == 'Sam Smoot') && u.admin == true }
        end

        it 'should return a Collection' do
          @return.should be_kind_of(DataMapper::Collection)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        unless loaded
          it 'should not be a kicker' do
            @subject.respond_to?(:loaded) and @subject.should_not be_loaded
          end
        end

        it 'should return expected values' do
          @return.should == [ @user ]
        end
      end

      describe 'with AND + OR conditions' do
        before :all do
          @return = @subject.send(method) { |u| (u.admin == true && u.name == 'Dan Kubb') || u.name == 'Sam Smoot' }
        end

        it 'should return a Collection' do
          @return.should be_kind_of(DataMapper::Collection)
        end

        it 'should not return self' do
          @return.should_not equal(@subject)
        end

        unless loaded
          it 'should not be a kicker' do
            @subject.respond_to?(:loaded) and @subject.should_not be_loaded
          end
        end

        it 'should return expected values' do
          @return.should == [ @user, @other ]
        end
      end
    end
  end

  [ :detect, :find ].each do |method|
    it { @subject.should respond_to(method) }

    describe "##{method}", ('(loaded)' if loaded) do
      describe 'with simple conditions' do
        before :all do
          @return = @subject.send(method) { |u| u.name == 'Dan Kubb' }
        end

        it 'should return a Resource' do
          @return.should be_kind_of(DataMapper::Resource)
        end

        unless loaded
          it 'should not be a kicker' do
            @subject.respond_to?(:loaded) and @subject.should_not be_loaded
          end
        end

        it 'should return expected value' do
          @return.should == @user
        end
      end

      describe 'with OR + AND conditions' do
        before :all do
          @return = @subject.send(method) { |u| (u.name == 'Dan Kubb' || u.name == 'Sam Smoot') && u.admin == true }
        end

        it 'should return a Resource' do
          @return.should be_kind_of(DataMapper::Resource)
        end

        unless loaded
          it 'should not be a kicker' do
            @subject.respond_to?(:loaded) and @subject.should_not be_loaded
          end
        end

        it 'should return expected value' do
          @return.should == @user
        end
      end

      describe 'with AND + OR conditions' do
        before :all do
          @return = @subject.send(method) { |u| (u.admin == true && u.name == 'Dan Kubb') || u.name == 'Sam Smoot' }
        end

        it 'should return a Resource' do
          @return.should be_kind_of(DataMapper::Resource)
        end

        unless loaded
          it 'should not be a kicker' do
            @subject.respond_to?(:loaded) and @subject.should_not be_loaded
          end
        end

        it 'should return expected value' do
          @return.should == @user
        end
      end
    end
  end

  it { @subject.should respond_to(:reject) }

  describe '#reject', ('(loaded)' if loaded) do
    describe 'with simple conditions' do
      before :all do
        @return = @subject.reject { |u| u.name != 'Dan Kubb' }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should not return self' do
        @return.should_not equal(@subject)
      end

      unless loaded
        it 'should not be a kicker' do
          @subject.respond_to?(:loaded) and @subject.should_not be_loaded
        end
      end

      it 'should return expected values' do
        @return.should == [ @user ]
      end
    end

    describe 'with OR + AND conditions' do
      before :all do
        @return = @subject.reject { |u| (u.name == 'Dan Kubb' || u.name == 'Sam Smoot') && u.admin == true }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should not return self' do
        @return.should_not equal(@subject)
      end

      unless loaded
        it 'should not be a kicker' do
          @subject.respond_to?(:loaded) and @subject.should_not be_loaded
        end
      end

      it 'should return expected values' do
        @return.should == [ @other ]
      end
    end

    describe 'with AND + OR conditions' do
      before :all do
        @return = @subject.reject { |u| (u.admin == true && u.name == 'Dan Kubb') || u.name == 'Sam Smoot' }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should not return self' do
        @return.should_not equal(@subject)
      end

      unless loaded
        it 'should not be a kicker' do
          @subject.respond_to?(:loaded) and @subject.should_not be_loaded
        end
      end

      it 'should return expected values' do
        @return.should == []
      end
    end
  end
end
