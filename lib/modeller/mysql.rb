require 'mysql2'
require 'active_support/core_ext/string'

module Modeller
  class MySql < Modeller::DatabaseAdapter
    
    def initialize(host, username, password=nil, database=nil)
      @client = Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
    end
    
    def scan_tables
      r = []
      get_tables.each do |tablename|
        r << get_table_info( tablename )
        File.open("#{tablename}.rb", "w") do |f|
          f.write("class #{tablename.classify} < ActiveRecord::Base\n")
          f.write("end\n")
        end
      end
    end

    def get_tables
      @client.query("SHOW TABLES").map{|row| row.values.first}
    end
    
    def get_table_info(tablename)
      child = [tablename]
      results = []
      tbl_stmt = @client.query("SHOW CREATE TABLE #{tablename}").map{|row| row["Create Table"]}.first
      re = /FOREIGN KEY \(`(\w+)`\) REFERENCES `(\w+)` \(`(\w+)`\)/
      tbl_stmt.scan(re).each do |fields|
        temp = child << fields
        results << temp
      end
      results
    end
  end
end
      
