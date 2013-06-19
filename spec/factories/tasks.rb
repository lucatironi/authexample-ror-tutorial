FactoryGirl.define do
  factory :task do

    sequence(:title) { |n| "Task ##{n}" }
    completed false
    user

    factory :completed_task do
      completed true
    end

  end
end