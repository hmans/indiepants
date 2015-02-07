namespace :indiepants do
  desc "Set up / update your IndiePants installation."
  task :update => ["db:create", "db:migrate"] do
  end
end
