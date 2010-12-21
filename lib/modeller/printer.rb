module Modeller
  class Printer
    @@path = "#{Rails.root || "."}/app/models/" # outside the Rails env?
    
    def self.print_model(model)
      if File.exists?("#{@@path}#{model.filename}") 
        puts "Warning: #{@@path}#{model.filename} exists. Not overwriting."
      else
        File.open("#{@@path}#{model.filename}", "w") do |f|
          f.write(model.to_s)
        end
      end
    end
  end
end