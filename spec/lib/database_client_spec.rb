require 'spec_helper'
require 'modeller'
require 'ruby-debug'

describe "Modeller::DatabaseClient" do
  describe ".get_client" do
    it "returns the correct client per the database.yml file" do
      Modeller::DatabaseClient.get_client.should be_a(Modeller::MysqlClient)
    end
  end
  
  describe "#scan_tables" do
    before(:all) do
      @client = Modeller::DatabaseClient.get_client
    end
    
    after(:each) do
      File.delete("#{Rails.root || "."}/app/models/user.rb")
      File.delete("#{Rails.root || "."}/app/models/company.rb")
      File.delete("#{Rails.root || "."}/app/models/schema_migration.rb")
    end
    
    it "should return a non-empty list for a database with tables" do
      models = @client.scan_tables
      models.should_not be_empty
    end
    
    it "should return a set of models" do
      models = @client.scan_tables
      models.first.should be_a(Modeller::Model)
    end
    
    it "should return a contain a model with an existing tablename" do
      models = @client.scan_tables
      models.first.tablename.should == 'companies'
    end
    
    describe "when the table has no foreign keys" do
      before(:each) do
        models = @client.scan_tables
        models.each do |model|
          @schema_model = model if 'schema_migrations' == model.tablename
        end
      end
      
      it "should return a valid model" do
        @schema_model.should be_a(Modeller::Model)
      end
      
      it "should have an empty one-to-many relationship hash" do
        @schema_model.relationships[:one_to_many].keys.should be_empty
      end
      
      it "should have an empty many_to_many relationship hash" do
        @schema_model.relationships[:many_to_many].keys.should be_empty
      end
      
      it "should have an empty many_to_one relationship hash" do
        @schema_model.relationships[:many_to_one].keys.should be_empty
      end
    end
    
    describe "when the table has one foreign key (many_to_one)" do
      before(:each) do
        models = @client.scan_tables
        models.each do |model|
          @companies_model = model if 'companies' == model.tablename
          @users_model = model if 'users' == model.tablename
        end
      end
      
      it "should return a valid model" do
        @companies_model.should be_a(Modeller::Model)
      end
      it "should have an empty one-to-many relationship hash" do
        @companies_model.relationships[:one_to_many].keys.should be_empty
      end
      
      it "should have an empty many-to-many relationship hash" do
        @companies_model.relationships[:many_to_many].keys.should be_empty
      end
      
      it "should have one item in the many-to-one relationship hash" do
        @companies_model.relationships[:many_to_one].keys.size.should == 1
      end
      
      it "should have a parent with one item in its one-to-many relationship hash" do
        @users_model.relationships[:one_to_many].keys.size.should == 1
      end
    end
  end
end