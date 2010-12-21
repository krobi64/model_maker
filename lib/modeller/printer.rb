module Modeller
  class Printer
    @@path = "#{Rails.root || "."}/app/models/" # outside the Rails env?
    
    def self.print_model(model)
      File.open("#{@@path}#{model.filename}", "w") do |f|
        f.write(model.to_s)
      end
    end
  end
end