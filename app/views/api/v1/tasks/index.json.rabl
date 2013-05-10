object false
node (:success) { true }
node (:info) { 'ok' }
child :data do
  node (:tasks_count) { @tasks.size }
  child @tasks do
    attributes :id, :title, :created_at, :completed
  end
end