require 'spec_helper'
require 'modeller'

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
        tables.size.should == 2
      end
    end

    describe "#get_table_info" do
      it "should return an empty set for a table with no fk relationships" do
        fks = @mysql.get_table_info 'user'
        fks.should be_empty
      end
      
      it "should return a non-zero sized set for a table with at least one fk relationship" do
        fks = @mysql.get_table_info 'user'
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
    end
    
  end
end