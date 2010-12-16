module Modeller
  class DatabaseAdapter
    
    def scan_tables
      r = []
      get_tables.each do |tablename|
        r << get_table_info( tablename )
      end
      Modeller::Model.create_models(r).each do |model|
        Modeller::Printer.print_model(model)
      end
    end
  end
end