require 'mysql2'
require 'modeller/printer'

module Modeller
  class MySql < Modeller::DatabaseAdapter
    
    def initialize(host, username, password=nil, database=nil)
      @client = Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
    end
    
    def get_tables
      super
      @client.query("SHOW TABLES").map{|row| row.values.first}
    end
    
    def get_table_info(tablename)
      super
      child = [tablename]
      results = []
      tbl_stmt = @client.query("SHOW CREATE TABLE #{tablename}").map{|row| row["Create Table"]}.first
      re = /FOREIGN KEY \(`(\w+)`\) REFERENCES `(\w+)` \(`(\w+)`\)/
      if tbl_stmt =~ re
        tbl_stmt.scan(re).each do |fields|
          temp = child << fields
          results << temp
        end
      else
        #No parent or child relationships
        results << [child.first, nil, nil, nil]
      end
      results
    end
    
  end
end
      
