namespace :gems do
  
  ree_gem = "/opt/ruby-enterprise/bin/gem"
  desc "Install RubyGems"
  task :install_rubygems, :roles => :app do
    run "wget -nv http://rubyforge.org/frs/download.php/45905/rubygems-#{rubygem_version}.tgz"
    run "tar xvzf rubygems-#{rubygem_version}.tgz"
    run "cd rubygems-#{rubygem_version} && sudo ruby setup.rb"
    sudo "ln -s /usr/bin/gem1.8 /usr/bin/gem"
    sudo "gem update"
    sudo "gem update --system"
    run "rm -Rf rubygems-#{rubygem_version}*"
  end
  
  desc "List gems on remote server"
  task :list, :roles => :app do
    stream "#{ree_gem} list"
  end

  desc "Update gems on remote server"
  task :update, :roles => :app do
    sudo "#{ree_gem} update"
  end
  
  desc "Update gem system on remote server"
  task :update_system, :roles => :app do
    sudo "#{ree_gem} update --system"
  end

  desc "Install a gem on the remote server"
  task :install, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we install: ")
    sudo "#{ree_gem} install #{name}"
  end

  desc "Uninstall a gem on the remote server"
  task :uninstall, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we uninstall: ")
    sudo "#{ree_gem} uninstall #{name}"
  end
  
  desc "List gem sources on remote server"
  task :list_sources, :roles => :app do
    stream "#{ree_gem} sources"
  end

  desc "Add a gem source on the remote server"
  task :add_source, :roles => :app do
    url = Capistrano::CLI.ui.ask("What source URL should we add: ")
    sudo "#{ree_gem} sources --add #{url}"
  end

  desc "Remove a gem source on the remote server"
  task :remove_source, :roles => :app do
    url = Capistrano::CLI.ui.ask("What source URL should we remove: ")
    sudo "#{ree_gem} sources --remove #{url}"
  end
end
