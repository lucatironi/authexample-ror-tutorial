require 'spec_helper'

describe Api::V1::SessionsController do

  it { expect(:post => "/api/v1/sessions.json").to route_to(:controller => 'api/v1/sessions', :action => 'create', :format => 'json') }
  it { expect(:delete => "/api/v1/sessions.json").to route_to(:controller => 'api/v1/sessions', :action => 'destroy', :format => 'json') }

end

describe Api::V1::RegistrationsController do

  it { expect(:post => "/api/v1/registrations.json").to route_to(:controller => 'api/v1/registrations', :action => 'create', :format => 'json') }

end