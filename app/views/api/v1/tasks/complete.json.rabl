object false
node (:success) { true }
node (:info) { 'Task completed!' }
child :data do
  child @task do
    attributes :id, :title, :created_at, :completed
  end
end