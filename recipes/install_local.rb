# download deploy keys
key_dir = "#{node[:raven_db][:local_dir]}/deploy_keys"
raven_deploy_tarball node[:raven_db][:deploy_keys_tarball] do
	directory key_dir
end

# installs database schema locally
node[:raven_db][:local].each do |name,db|

	deploy_key_path = "#{key_dir}/#{db[:name]}-schema-deploy.key"

	raven_db_local db[:name] do
		repository db[:repo]
		branch db[:branch]
		deploy_key deploy_key_path
		pass node[:raven_db][:root_password]
	end
end
