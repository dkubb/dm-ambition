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
      property :admin, Boolean
    end
  end

  before :all do
    @repository = DataMapper.repository(:default)
    @model      = User

    @subject = @model
  end

  before :all do
    DataMapper.auto_migrate!

    @user = @model.create(:name => 'Dan Kubb')
  end

  it_should_behave_like 'it has public filter methods'
end
