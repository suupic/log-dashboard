class RealtimeCache
  def initialize(server='127.0.0.1',port='27017')
  	  @conn = Mongo::Connection.new('172.16.3.53')  
  	  @fluentd = @conn['fluent']
  end

  def push(msg)
    @msg = msg
  end

  def pull(collection_name, start_at, record_limit = 10 )
    collection = @fluentd["#{collection_name}"]
    collection.find(time: {"$gt" => start_at.utc}).sort({time: 1}).limit(record_limit)
  end

	def create_cursor_conf(collection, conf)
	  skip = collection.count - conf[:n]
	  cursor_conf = {}
	  cursor_conf[:skip] = skip if skip > 0
	  cursor_conf
	end

  def tail_forever(collection_name)
  	collection = @fluentd["#{collection_name}"]
    cursor_conf = {}
    cursor_conf[:tailable] = true

    cursor = Mongo::Cursor.new(collection, cursor_conf)
    uri = URI.parse("http://localhost:9292/faye")
    loop {
      # TODO: Check more detail of cursor state if needed
      cursor = Mongo::Cursor.new(collection, cursor_conf) unless cursor.alive?

      if doc = cursor.next_document
      	current_doc = doc.to_json
      	#essage = 'loop msg'
			  message = {:channel => "/logs/testlog", :data => { :resource_id => '1', :message => current_doc }}
        Net::HTTP.post_form(uri, :message => message.to_json)   
      else
        sleep 1
      end
    }
  rescue
    # ignore Mongo::OperationFailuer at CURSOR_NOT_FOUND
  end

end