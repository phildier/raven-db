actions :create, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :repository, :kind_of => String
attribute :branch, :kind_of => String
attribute :deploy_key, :kind_of => String
attribute :host, :kind_of => String, :default => "127.0.0.1"
attribute :port, :kind_of => Integer, :default => 3306
attribute :user, :kind_of => String, :default => "root"
attribute :pass, :kind_of => String, :default => ""
