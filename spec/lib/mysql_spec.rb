require 'spec_helper'
require 'modeller'
require 'ruby-debug'

describe 'Modeller::MySql' do
  describe "#new" do
    it "should raise an error upon invalid parameters" do
      lambda{
        mysql = Modeller::MySql.new('localhost', 'root', 'madeup', 'model_maker_test')
      }.should raise_error
    end
    
    it "should return a mysql client given valid parameters" do
      mysql = Modeller::MySql.new('localhost', 'root', '', 'model_maker_test')
    end
  end
  
  context "instantiated" do
    
    before(:each) do
      @mysql = Modeller::MySql.new('localhost', 'root', '', 'model_maker_test')      
    end
    describe "#get_tables" do
      it "should return a list of tables in the database" do
        tables = @mysql.get_tables
        tables.size.should == 3
      end
    end

    describe "#get_table_info" do
      it "should return one item for each table" do
        fks = @mysql.get_table_info 'users'
        fks.should_not be_empty
      end
    end
    
    describe "#scan_tables" do
      it "should return a non-empty list for a database with tables" do
        models = @mysql.scan_tables
        models.should_not be_empty
      end
      
      it "should return a set of models" do
        models = @mysql.scan_tables
        models.first.should be_a(Modeller::Model)
      end
      
      it "should return a contain a model with an existing tablename" do
        models = @mysql.scan_tables
        models.first.tablename.should == 'companies'
      end
      
      describe "when the table has no foreign keys" do
        before(:each) do
          models = @mysql.scan_tables
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
          # debugger
          models = @mysql.scan_tables
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
end