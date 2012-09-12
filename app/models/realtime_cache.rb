class RealtimeCache
  def initialize(server='127.0.0.1',port='27017')
  	  @conn = Mongo::Connection.new('172.16.3.53')
	  p "conn: #{@conn}"  	  
  	  @fluentd = @conn['fluent']
  end

  def push(msg)
    @msg = msg
  end

  def pop(collection_name)
    p "fluent: #{collection_name}"
    collection = @fluentd["#{collection_name}"]
    collection.find.sort({time: -1}).limit(10)
  end
end