class ResourcesController < ApplicationController
  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render json: @resource, status: :created, location: @resource }
      else
        format.html { render action: "new" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end

  def flush
    @resource = Resource.find(params[:id])
    if @resource
      message = {:channel => "/logs/#{@resource.name}", :data => { :resource_id => @resource.id, :message => RealtimeCache.new.pull(@resource.collection) }}
      uri = URI.parse("http://localhost:9292/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
    end
    render :nothing => true
  end

  def pull    
    @resource = Resource.find(params[:id])
    if params[:resource]
      time_string = "#{params[:resource]['search_start_at(1i)']}-#{params[:resource]['search_start_at(2i)']}-#{params[:resource]['search_start_at(3i)']} #{params[:resource]['search_start_at(4i)']}:#{params[:resource]['search_start_at(5i)']}"
      @resource.search_start_at = Time.parse(time_string).in_time_zone('Beijing')
      
      @resource.search_limit_count = params[:resource][:search_limit_count].to_i
      @logdata = RealtimeCache.new.pull(@resource.collection, @resource.search_start_at, @resource.search_limit_count)      
    else 
      @resource.search_start_at = Time.now - 1.hour
      @resource.search_limit_count = 500
    end

   # @resource.search_limit_count = params[:search]

=begin

    if request.headers['X-PJAX']
      render :layout => false
    end =end


=begin
    respond_to do |format|
        format.html
        format.json { render json: @resource, json: @logdata }
    end    
=end

  end


end
