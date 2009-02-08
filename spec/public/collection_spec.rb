require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

[ false, true ].each do |loaded|
  describe DataMapper::Ambition::Collection do
    cattr_accessor :loaded

    self.loaded = loaded

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
      @collection = DataMapper::Collection.new(@query)

      @collection.to_a if loaded

      @subject = @collection
    end

    before :all do
      DataMapper.auto_migrate!

      @user = @model.create(:name => 'Dan Kubb')
    end

    it_should_behave_like 'it has public filter methods'
  end
end
