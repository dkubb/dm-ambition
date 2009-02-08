share_examples_for 'it has public filter methods' do
  [ :select, :find_all ].each do |method|
    it { @subject.should respond_to(method) }

    describe "##{method}", ('(loaded)' if loaded) do
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
          pending 'TODO: make Collection#equal not a kicker' do
            @return.should_not be_loaded
          end
        end
      end

      it 'should return expected values' do
        @return.should == [ @user ]
      end
    end
  end

  [ :detect, :find ].each do |method|
    it { @subject.should respond_to(method) }

    describe "##{method}", ('(loaded)' if loaded) do
      before :all do
        @return = @subject.send(method) { |u| u.name == 'Dan Kubb' }
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should return expected value' do
        @return.should == @user
      end
    end
  end

  it { @subject.should respond_to(:reject) }

  describe '#reject', ('(loaded)' if loaded) do
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
        pending 'TODO: make Collection#equal not a kicker' do
          @return.should_not be_loaded
        end
      end
    end

    it 'should return expected values' do
      @return.should == [ @user ]
    end
  end
end
