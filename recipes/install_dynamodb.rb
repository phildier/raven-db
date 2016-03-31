include_recipe "raven-supervisor"

package "java-1.8.0-openjdk"

dynamodb_dir = "/var/lib/dynamodb"
dynamodb_datadir = "#{dynamodb_dir}/dynamodb"

directory dynamodb_dir
directory dynamodb_datadir do
	user "nobody"
	group "nobody"
end

remote_file "#{node[:raven_deploy][:attachments_dir]}/dynamodb.tar.gz" do
	source "http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz"
end

bash "extract dynamodb" do
	cwd dynamodb_dir
	code <<-EOH
	tar xf "#{node[:raven_deploy][:attachments_dir]}/dynamodb.tar.gz"
	EOH
	not_if { ::File.exists?("#{dynamodb_dir}/DynamoDBLocal.jar") }
end

cmd = [
	"java -Djava.library.path=#{dynamodb_dir}/DynamoDBLocal_lib",
    "-jar #{dynamodb_dir}/DynamoDBLocal.jar",
    "-sharedDb",
    "-dbPath #{dynamodb_datadir}"
].join(" ")

raven_supervisor_program "dynamodb" do
	directory dynamodb_dir
	command cmd
	numprocs 1
	notifies :restart, "service[supervisord]", :delayed
end
