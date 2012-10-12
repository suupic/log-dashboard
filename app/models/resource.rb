class Resource < ActiveRecord::Base
  attr_accessible :collection, :database, :description, :name
  attr_accessor :search_start_at, :search_limit_count

  def get_binding
    binding
  end

end
