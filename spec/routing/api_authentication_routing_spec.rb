require 'spec_helper'

describe Api::V1::SessionsController do

  it { should route(:post, "/api/v1/sessions.json").to(controller: 'api/v1/sessions', action: 'create', format: :json) }
  it { should route(:delete, "/api/v1/sessions.json").to(controller: 'api/v1/sessions', action: 'destroy', format: :json) }

end

describe Api::V1::RegistrationsController do

  it { should route(:post, "/api/v1/registrations.json").to(controller: 'api/v1/registrations', action: 'create', format: :json) }

end