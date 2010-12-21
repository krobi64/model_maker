require 'yaml'

module Modeller
  class DatabaseClient
    
    @@db_yml = "#{Rails.root}/config/database.yml"
    
    def get_tables
    end
    
    def get_table_info(tablename)
    end
        
    def scan_tables
      r = []
      get_tables.each do |tablename|
        r << get_table_info( tablename )
      end
      Modeller::Model.create_models(r).each do |model|
        Modeller::Printer.print_model(model)
      end
    end
    
    def self.get_client
      if File.exists?(@@db_yml) && File.file?(@@db_yml)
        db_conf = YAML.load_file(@@db_yml)
        #TODO Warn if using production environment
        raise Error.new("Not for use in production environment") if "production" == Rails.env
        db_env = db_conf[Rails.env]
        case db_env["adapter"]
        when 'mysql2'
          host = db_env["host"].nil? ? 'localhost' : db_env["host"]
          Modeller::MysqlClient.new(host, db_env["username"], db_env["password"], db_env["database"])
        end 
      else
        raise Error.new("#{@@db_yml} not found")
      end
    end
  end
end