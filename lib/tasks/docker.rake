namespace :docker do
  desc "Build Docker image using current code"
  task :build do
    sh 'docker build -t hmans/indiepants .'
  end

  # NOTE: we will use Fig aka docker-compose in the future.
  #
  # desc "Run the Docker image in the foreground."
  # task :run do
  #   sh 'docker run --rm -e SECRET_KEY_BASE=abcdefgh12345678 --link indiepants-postgres:postgres --name indiepants -p 8080:80 hmans/indiepants'
  # end
  #
  # desc "Start the daemonized Docker container."
  # task :start do
  #   sh 'docker run -e SECRET_KEY_BASE=abcdefgh12345678 --link indiepants-postgres:postgres -d --name indiepants -p 8080:80 hmans/indiepants'
  # end
  #
  # desc "Stop the daemonized Docker container."
  # task :stop do
  #   sh 'docker stop indiepants'
  #   sh 'docker rm indiepants'
  # end
end
