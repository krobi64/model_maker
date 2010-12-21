require 'spec_helper'
require 'modeller'
require 'ruby-debug'

describe 'Modeller::MysqlClient' do
  describe "#new" do
    it "should raise an error upon invalid parameters" do
      lambda{
        mysql = Modeller::MysqlClient.new('localhost', 'root', 'madeup', 'model_maker_test')
      }.should raise_error
    end
    
    it "should return a mysql client given valid parameters" do
      mysql = Modeller::MysqlClient.new('localhost', 'root', '', 'model_maker_test')
    end
  end
  
  context "instantiated" do
    
    before(:each) do
      @mysql = Modeller::MysqlClient.new('localhost', 'root', '', 'model_maker_test')      
    end
    describe "#get_tables" do
      it "should return a list of tables in the database" do
        tables = @mysql.get_tables
        tables.size.should == 3
      end
    end

    describe "#get_table_info" do
      it "should return one item for each unrelated table" do
        fks = @mysql.get_table_info 'schema_migrations'
        fks.size.should == 1
      end
      
      it "should return one item for each table with a single foreign key" do
        fks = @mysql.get_table_info 'users'
        fks.size.should == 1
      end
    end    
  end
end