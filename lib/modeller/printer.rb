module Modeller
  class Printer
    def initializer
      @path = "#{Rails.root}/app/models"
    end
    
    def self.print_model(model)
      File.open("#{model.filename}", "w") do |f|
        f.write(model.to_s)
      end
    end
  end
end