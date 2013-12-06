class MonitorRecordsController < ApplicationController
  # GET /monitor_records
  # GET /monitor_records.xml
  def index
  	# was .all
    @monitor_records = MonitorRecord.recent


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @monitor_records }
    end
  end

  # GET /monitor_records/1
  # GET /monitor_records/1.xml
  def show
    @monitor_record = MonitorRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @monitor_record }
    end
  end

  # GET /monitor_records/new
  # GET /monitor_records/new.xml
  def new
    @monitor_record = MonitorRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @monitor_record }
    end
  end

  # GET /monitor_records/1/edit
  def edit
    @monitor_record = MonitorRecord.find(params[:id])
  end

  # POST /monitor_records
  # POST /monitor_records.xml
  def create
    @monitor_record = MonitorRecord.new(params[:monitor_record])

    respond_to do |format|
      if @monitor_record.save
        flash[:notice] = 'MonitorRecord was successfully created.'
        format.html { redirect_to(@monitor_record) }
        format.xml  { render :xml => @monitor_record, :status => :created, :location => @monitor_record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @monitor_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /monitor_records/1
  # PUT /monitor_records/1.xml
  def update
    @monitor_record = MonitorRecord.find(params[:id])

    respond_to do |format|
      if @monitor_record.update_attributes(params[:monitor_record])
        flash[:notice] = 'MonitorRecord was successfully updated.'
        format.html { redirect_to(@monitor_record) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @monitor_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /monitor_records/1
  # DELETE /monitor_records/1.xml
  def destroy
    @monitor_record = MonitorRecord.find(params[:id])
    @monitor_record.destroy

    respond_to do |format|
      format.html { redirect_to(monitor_records_url) }
      format.xml  { head :ok }
    end
  end
end
