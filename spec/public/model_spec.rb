require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe DataMapper::Ambition::Model do
  def self.loaded
    false
  end

  before :all do
    class ::User
      include DataMapper::Resource

      property :id,    Serial
      property :name,  String
      property :admin, Boolean, :default => false
    end

    @model      = User
  end

  supported_by :all do
    before :all do
      @user  = @model.create(:name => 'Dan Kubb', :admin => true)
      @other = @model.create(:name => 'Sam Smoot')

      @subject = @model
    end

    it_should_behave_like 'it has public filter methods'
  end
end
