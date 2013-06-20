require 'spec_helper'

describe Api::V1::TasksController do

  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, :user => user) }
  let(:completed_task) { FactoryGirl.create(:completed_task, :user => user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:another_user_task) { FactoryGirl.create(:task, :user => another_user) }

  let(:json_response) { response.body }
  let(:parsed_response) { JSON.parse(json_response) }

  describe "GET 'index'" do
    before do
      task
      completed_task
      another_user_task
    end

    context "with valid credentials" do
      before { get '/api/v1/tasks.json', nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\""} }

      specify { response.should be_success }

      specify { json_response.should have_json_path('info') }
      specify { json_response.should have_json_path('data/tasks_count') }

      specify { parsed_response['info'].should eq('ok') }
      specify { parsed_response['data']['tasks_count'].should eq(2) }

      specify { json_response.should have_json_path('data/tasks') }
      specify { json_response.should have_json_size(2).at_path('data/tasks') }
      specify { json_response.should include_json(task.to_json).excluding('user_id').at_path('data/tasks') }
      specify { json_response.should include_json(completed_task.to_json).excluding('user_id').at_path('data/tasks') }
    end

    context "with invalid credentials" do
      before { get '/api/v1/tasks.json', nil, { 'HTTP_AUTHORIZATION' => "Token token=\"not-a-token\""} }

      specify { response.status.should eq(401) }
      specify { json_response.should have_json_path('error') }
      specify { json_response.should_not have_json_path('data') }
      specify { parsed_response['error'].should eq(I18n.t("devise.failure.invalid_token")) }
    end

    context "scopes tasks by user" do
      before { get '/api/v1/tasks.json', nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\""} }

      specify { json_response.should_not include_json(another_user_task.to_json).excluding('user_id').at_path('data/tasks') }
    end
  end

  describe "POST 'create'" do
    context "with valid credentials" do
      before { post '/api/v1/tasks.json', { :task => { :title => 'Test Task' } }, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

      specify { response.should be_success }
      specify { json_response.should have_json_path('info') }
      specify { parsed_response['info'].should eq('Task created!') }

      specify { json_response.should have_json_path('data/task') }
      specify { json_response.should be_json_eql({ :title => 'Test Task', :completed => false }.to_json).excluding('user_id').at_path('data/task') }
    end

    context "with invalid credentials" do
      before { post '/api/v1/tasks.json', { :task => { :title => 'Test Task' } }, { 'HTTP_AUTHORIZATION' => "Token token=\"not-a-token\"" } }

      specify { response.status.should eq(401) }
      specify { json_response.should have_json_path('error') }
      specify { json_response.should_not have_json_path('data') }
      specify { parsed_response['error'].should eq(I18n.t("devise.failure.invalid_token")) }
    end

    context "with invalid attributes" do
      before { post '/api/v1/tasks.json', { :task => { :title => '' } }, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

      specify { response.status.should eq(422) }
      specify { json_response.should have_json_path('info') }
      specify { parsed_response['info'].should_not be_nil }
      specify { parsed_response['data'].should be_empty }
    end
  end

  describe "PUT 'open'" do
    context "with valid credentials" do
      before { put "/api/v1/tasks/#{completed_task.id}/open.json", nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

      specify { response.should be_success }
      specify { json_response.should have_json_path('info') }
      specify { parsed_response['info'].should eq('Task opened!') }

      specify { json_response.should have_json_path('data/task') }
      specify { json_response.should be_json_eql({ :title => completed_task.title, :completed => false }.to_json).excluding('user_id').at_path('data/task') }
    end

    context "with invalid credentials" do
      context "invalid token" do
        before { put "/api/v1/tasks/#{completed_task.id}/open.json", nil, { 'HTTP_AUTHORIZATION' => "Token token=\"not-a-token\"" } }

        specify { response.status.should eq(401) }
        specify { json_response.should have_json_path('error') }
        specify { json_response.should_not have_json_path('data') }
        specify { parsed_response['error'].should eq(I18n.t("devise.failure.invalid_token")) }
      end

      context "with invalid id" do
        before { put "/api/v1/tasks/#{another_user_task.id}/open.json", nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

        specify { response.status.should eq(404) }
        specify { json_response.should have_json_path('info') }
        specify { parsed_response['info'].should eq('Not Found') }
        specify { parsed_response['data'].should be_empty }
      end
    end
  end

  describe "PUT 'complete'" do
    context "with valid credentials" do
      before { put "/api/v1/tasks/#{task.id}/complete.json", nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

      specify { response.should be_success }
      specify { json_response.should have_json_path('info') }
      specify { parsed_response['info'].should eq('Task completed!') }

      specify { json_response.should have_json_path('data/task') }
      specify { json_response.should be_json_eql({ :title => task.title, :completed => true }.to_json).excluding('user_id').at_path('data/task') }
    end

    context "with invalid credentials" do
      context "invalid token" do
        before { put "/api/v1/tasks/#{task.id}/complete.json", nil, { 'HTTP_AUTHORIZATION' => "Token token=\"not-a-token\"" } }

        specify { response.status.should eq(401) }
        specify { json_response.should have_json_path('error') }
        specify { json_response.should_not have_json_path('data') }
        specify { parsed_response['error'].should eq(I18n.t("devise.failure.invalid_token")) }
      end

      context "with invalid id" do
        before { put "/api/v1/tasks/#{another_user_task.id}/complete.json", nil, { 'HTTP_AUTHORIZATION' => "Token token=\"#{user.authentication_token}\"" } }

        specify { response.status.should eq(404) }
        specify { json_response.should have_json_path('info') }
        specify { parsed_response['info'].should eq('Not Found') }
        specify { parsed_response['data'].should be_empty }
      end
    end
  end

end