class Api::V1::TasksController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
  end

  def create
    @task = current_user.tasks.build(params[:task])
    if @task.save
      @task
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @task.errors.full_messages,
                        :data => {} }
    end
  end

  def open
    @task = current_user.tasks.find(params[:id])
    @task.open!
  rescue ActiveRecord::RecordNotFound
    render :status => 404,
           :json => { :success => false,
                      :info => 'Not Found',
                      :data => {} }
  end

  def complete
    @task = current_user.tasks.find(params[:id])
    @task.complete!
  rescue ActiveRecord::RecordNotFound
    render :status => 404,
           :json => { :success => false,
                      :info => 'Not Found',
                      :data => {} }
  end
end