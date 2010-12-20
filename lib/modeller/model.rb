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
    attr_accessor :tablename, :modelname, :filename, :relationships
    
    def initialize(tablename=nil)
      @tablename = tablename
      @modelname = tablename.classify unless tablename.nil?
      @filename = "#{tablename.singularize}.rb"
      @relationships = {:one_to_many => {}, :many_to_one => {}, :many_to_many => {}}
    end
    
    def has_many(model, index, foreign_key)
      child = @relationships[:many_to_one].delete(model)
      if child
        @relationships[:many_to_many][model] = Modeller::Relationship.new(:many_to_many, model, foreign_key, index )
      else
        @relationships[:one_to_many][model] = Modeller::Relationship.new(:many_to_one, model, foreign_key, index )
      end
    end
    
    def belongs_to(model, index, foreign_key)
      parent = @relationships[:one_to_many].delete(model)
      if parent
        @relationships[:many_to_many][model] = Modeller::Relationship.new(:many_to_many, model, foreign_key, index )
      else
        @relationships[:many_to_one][model] = Modeller::Relationship.new(:many_to_one, model, foreign_key, index )
      end
    end
    
    def to_s
      stmt = "class #{@modelname} < ActiveRecord::Base\n"
      @relationships[:one_to_many].each do |k,v|
        stmt << "  has_many :#{v.model.tablename}\n"
      end
      @relationships[:many_to_one].each do |k,v|
        stmt << "  belongs_to :#{v.model.tablename.singularize}\n" 
      end
      @relationships[:many_to_many].each do |k,v|
        stmt << "  belongs_to_and_has_many :#{v.model.tablename}\n"
      end
      stmt << "end"
    end
    
    def self.create_models(rlist)
      result = {}
      rlist.each do |item|
        tablename, foreign_key, parent, index = item.flatten
        result[tablename] = Modeller::Model.new(tablename) unless result.key?(tablename)
        if !parent.nil?
          result[parent] = Modeller::Model.new(parent) unless result.key?(parent)
          result[tablename].belongs_to(result[parent], index, foreign_key)
          result[parent].has_many(result[tablename], index, foreign_key)
        end
      end
      result.values
    end
    
  end
end