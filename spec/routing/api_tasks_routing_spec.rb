require 'spec_helper'

describe Api::V1::TasksController do

  it { expect(:get => "/api/v1/tasks.json").to route_to(:controller => 'api/v1/tasks', :action => 'index', :format => 'json') }
  it { expect(:post => "/api/v1/tasks.json").to route_to(:controller => 'api/v1/tasks', :action => 'create', :format => 'json') }
  it { expect(:put => "/api/v1/tasks/1/open.json").to route_to(:controller => 'api/v1/tasks', :action => 'open', :id => '1', :format => 'json') }
  it { expect(:put => "/api/v1/tasks/1/complete.json").to route_to(:controller => 'api/v1/tasks', :action => 'complete', :id => '1', :format => 'json') }

end