action :create do
	name = new_resource.name
	deploy_key = new_resource.deploy_key

	ssh_wrapper = "/tmp/.ssh/#{name}.sh"
	file ssh_wrapper do
		content <<-EOH
			/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "#{deploy_key}" $1 $2
		EOH
		mode 0700
	end

	bootstrap_resource_name = "bootstrap-db-#{name}"

	db_path = "#{node[:raven_db][:local_dir]}/#{name}"

	git db_path do
		repository new_resource.repository
		reference new_resource.branch
		action :sync
		ssh_wrapper ssh_wrapper
		notifies :run, "bash[#{bootstrap_resource_name}]", :immediately
	end

	dsn = {
		:database => name,
		:username => new_resource.user,
		:password => new_resource.pass,
		:host => new_resource.host,
		:port => new_resource.port
	}

	bash bootstrap_resource_name do
		action :nothing
		cwd "#{db_path}/scripts"
        code "php bootstrap.php #{dsn.to_json}"
	end
		
end

action :delete do
end
