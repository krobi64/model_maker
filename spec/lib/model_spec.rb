require 'spec_helper'
require 'modeller'
require 'ruby-debug'

describe "Modeller::Model" do
  describe ".new" do
    before(:each) do
      @m = Modeller::Model.new("users", "id")
    end
    
    it "returns a model object" do
      @m.should be_a(Modeller::Model)
    end
    
    it "should have an empty relationships object" do
      @m.relationships.keys.should include(:one_to_many)
      @m.relationships[:one_to_many].keys.should be_empty
      @m.relationships.keys.should include(:many_to_one)
      @m.relationships[:many_to_one].keys.should be_empty
      @m.relationships.keys.should include(:many_to_many)
      @m.relationships[:many_to_many].keys.should be_empty
    end
  end
  
  describe ".create_models" do
    
  end

  describe "#has_many" do
    before(:each) do
      @m = Modeller::Model.new("users", "id")
      @c = Modeller::Model.new("companies", "id")
    end
    
    describe "when the subject model does not have any existing relationships for the other model" do
      it "creates a one-to-many relationship" do
        @m.has_many(@c, 'c_index', 'm_fk')
        
        @m.relationships[:one_to_many].keys.first.should == @c
        @m.relationships[:many_to_one].keys.should be_empty
        @m.relationships[:many_to_many].keys.should be_empty        
      end      
    end
    
    describe "when the subject model already has a many-to-one relationship for the other model" do
      it "creates a many-to-many relationship" do
        @m.belongs_to(@c, 'c_index', 'm_fk')
        @m.has_many(@c, 'c_index', 'm_fk')
        @m.relationships[:one_to_many].keys.should be_empty
        @m.relationships[:many_to_one].keys.should be_empty
        @m.relationships[:many_to_many].keys.first.should == @c                
      end      
    end
  end
  
  describe "#belongs_to" do
    before(:each) do
      @m = Modeller::Model.new("users")
      @p = Modeller::Model.new("companies")
    end
    
    describe "when the subject model does not have any existing relationships for the other model" do
      it "creates a many-to-one relationship" do
        @m.belongs_to(@p, 'p_index', 'm_fk')
        
        @m.relationships[:one_to_many].keys.should be_empty
        @m.relationships[:many_to_one].keys.first.should == @p
        @m.relationships[:many_to_many].keys.should be_empty        
      end
    end
    
    describe "when the subject model already has a one-to-many relationship for with the other model" do
      it "creates a many-to-many relationship" do
        @m.has_many(@p, 'p_index', 'm_fk')
        @m.belongs_to(@p, 'p_index', 'm_fk')
        
        @m.relationships[:one_to_many].keys.should be_empty
        @m.relationships[:many_to_one].keys.should be_empty
        @m.relationships[:many_to_many].keys.first.should == @p                
      end
    end
  end
  
  
end