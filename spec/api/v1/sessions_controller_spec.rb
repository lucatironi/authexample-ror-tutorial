require 'spec_helper'

describe Api::V1::SessionsController do

  let(:user) { FactoryGirl.create(:user) }

  let(:json_response) { response.body }
  let(:parsed_response) { JSON.parse(json_response) }

  describe "POST 'create'" do
    context "with valid credentials" do
      before { post '/api/v1/sessions.json', user: { email: user.email, password: user.password } }

      specify { response.should be_success }
      specify { json_response.should have_json_path('info') }
      specify { json_response.should have_json_path('data/auth_token') }

      specify { parsed_response['info'].should eq(I18n.t("devise.sessions.signed_in")) }
      specify { parsed_response['data']['auth_token'].should eq(user.authentication_token) }
    end

    context "with invalid credentials" do
      before { post '/api/v1/sessions.json', user: { email: user.email, password: 'not-the-right-password' } }

      specify { response.status.should eq(401) }
      specify { json_response.should have_json_path('error') }
      specify { json_response.should_not have_json_path('data') }
      specify { parsed_response['error'].should eq(I18n.t("devise.failure.invalid")) }
    end
  end

  describe "DELETE 'destroy'" do
    context "with valid credentials" do
      before { delete '/api/v1/sessions.json', nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

      specify { response.should be_success }
      specify { json_response.should have_json_path('info') }
      specify { parsed_response['info'].should eq(I18n.t("devise.sessions.signed_out")) }
      specify { parsed_response['data'].should be_empty }
    end

    context "with invalid credentials" do
      before { delete '/api/v1/sessions.json', nil, { 'HTTP_AUTHORIZATION' => "Token token=\"not-a-token\"" } }

      specify { response.status.should eq(401) }
      specify { json_response.should have_json_path('error') }
      specify { json_response.should_not have_json_path('data') }
      specify { parsed_response['error'].should eq(I18n.t("devise.failure.invalid_token")) }
    end
  end

end