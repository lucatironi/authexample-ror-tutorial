require 'spec_helper'

describe Api::V1::RegistrationsController do

  let(:json_response) { response.body }
  let(:parsed_response) { JSON.parse(json_response) }

  describe "POST 'create'" do
    context "with valid credentials" do
      before(:all) { post '/api/v1/registrations.json', user: { name: 'John Doe', email: 'test@example.com', password: 'password' } }

      specify { response.should be_success }
      specify { json_response.should have_json_path('info') }
      specify { json_response.should have_json_path('data/user') }

      specify { parsed_response['info'].should eq(I18n.t("devise.registrations.signed_up")) }
      specify { parsed_response['data']['user']['email'].should eq 'test@example.com' }
      specify { parsed_response['data']['auth_token'].should_not be_nil }
    end

    context "with invalid credentials" do
      before { post '/api/v1/registrations.json', user: { email: 'test@example.com', password: '' } }

      specify { response.status.should eq(422) }
      specify { json_response.should have_json_path('info') }

      specify { parsed_response['info'].should_not be_empty }
      specify { parsed_response['data'].should be_empty }
    end
  end

end