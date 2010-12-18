require 'active_support/core_ext/string'

module Modeller
  class Relationship
    attr_accessor :hierarchy, :model, :local_key, :external_key
    
    def initialize(hierarchy=:many_to_one, model, local_key, external_key)
      raise Error.new("Invalid hierarchy") unless [:many_to_one, :one_to_many, :many_to_many].include?(hierarchy)
      @hierarchy = hierarchy
      @model = model
      @local_key = local_key
      @external_key = external_key
    end
  end
  
  class Model
    attr_accessor :tablename, :modelname
    
    def initialize(tablename=nil)
      @tablename = tablename
      @modelname = tablename.classify unless tablename.nil?
      @relationships = {}
    end
    
    def parent(model, index, foreign_key)
      child = @relationships[:child][model].delete
    end
    
    def self.create_models(rlist)
      result = []
    end
    
  end
end