class User < ActiveRecord::Base
  has_many :companies
end