require 'version'

namespace :xenapi do

  desc "Build docker image"
  # task :build, :environment do |t, args|
  task :build do
    # environment = args[:environment]

    puts "Building docker image"# for #{environment} environment"
    # FileUtils.cp "certs/api-#{environment}.xensan.com/xenapi-#{environment}.key", "docker-conf/certs/xenapi.key"
    # FileUtils.cp "certs/api-#{environment}.xensan.com/xenapi-#{environment}.crt", "docker-conf/certs/xenapi.crt"
    version = Version.current
    puts "version: #{version}"
    system(%Q{docker build -t xensan/xenapi:#{version} .})
    system(%Q{docker tag -f xensan/xenapi:#{version} xensan/xenapi:latest})
  end

  desc "Push the current docker image to docker hub"
  task :push do
    version = Version.current
    system(%Q{docker push xensan/xenapi:#{version}})
    system(%Q{docker push xensan/xenapi:latest})
  end

  desc "Create a zip file for AWS upload"
  task :aws do
    version = Version.current
    json = File.read("Dockerrun.aws.json.template")
    json.gsub!(/VERSION/, "#{version}")
    File.open("Dockerrun.aws.json", 'w') { |file| file.write(json) }
    system(%Q{zip -9 xenapi-#{version}.zip Dockerrun.aws.json})
  end

end
