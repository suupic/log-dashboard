class Resource < ActiveRecord::Base
  attr_accessible :collection, :database, :description, :name
end
