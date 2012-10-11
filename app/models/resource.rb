class Resource < ActiveRecord::Base
  attr_accessible :collection, :database, :description, :name
  attr_accessor :search_start_at, :search_limit_count
=begin
  
  def search_start_at=(start_at = Time.now)
  	Time.now if self.search_start_at.nil?
  end

  def search_limit_count
  end
=end

end
