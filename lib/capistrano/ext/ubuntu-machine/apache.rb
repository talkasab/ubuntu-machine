namespace :apache do
  desc "Install Apache"
  task :install, :roles => :web do
    sudo "apt-get install apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y"
    
    run "cat /etc/apache2/apache2.conf > ~/apache2.conf.tmp"
    put render("apache2", binding), "apache2.append.conf.tmp"
    run "cat apache2.append.conf.tmp >> ~/apache2.conf.tmp"
    sudo "mv ~/apache2.conf.tmp /etc/apache2/apache2.conf"
    run "rm apache2.append.conf.tmp"
    restart
  end
  
  desc "Restarts Apache webserver"
  task :restart, :roles => :web do
    sudo "/etc/init.d/apache2 restart"
  end

  desc "Starts Apache webserver"
  task :start, :roles => :web do
    sudo "/etc/init.d/apache2 start"
  end

  desc "Stops Apache webserver"
  task :stop, :roles => :web do
    sudo "/etc/init.d/apache2 stop"
  end

  desc "Reload Apache webserver"
  task :reload, :roles => :web do
    sudo "/etc/init.d/apache2 reload"
  end

  desc "Force reload Apache webserver"
  task :force_reload, :roles => :web do
    sudo "/etc/init.d/apache2 force-reload"
  end

  desc "List enabled Apache sites"
  task :enabled_sites, :roles => :web do
    run "ls /etc/apache2/sites-enabled"
  end

  desc "List available Apache sites"
  task :available_sites, :roles => :web do
    run "ls /etc/apache2/sites-available"
  end

  desc "List enabled Apache modules"
  task :enabled_modules, :roles => :web do
    run "ls /etc/apache2/mods-enabled"
  end

  desc "List available Apache modules"
  task :available_modules, :roles => :web do
    run "ls /etc/apache2/mods-available"
  end

  desc "Disable Apache site"
  task :disable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we disable: ")
    sudo "sudo a2dissite #{site}"
    reload
  end

  desc "Enable Apache site"
  task :enable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we enable: ")
    sudo "sudo a2ensite #{site}"
    reload
  end

  desc "Disable Apache module"
  task :disable_module, :roles => :web do
    mod = Capistrano::CLI.ui.ask("Which module should we disable: ")
    sudo "sudo a2dismod #{mod}"
    force_reload
  end

  desc "Enable Apache module"
  task :enable_module, :roles => :web do
    mod = Capistrano::CLI.ui.ask("Which module should we enable: ")
    sudo "sudo a2enmod #{mod}"
    force_reload
  end

  desc "Create a new website"
  task :create_website, :roles => :web do
    site_name     = Capistrano::CLI.ui.ask("Site name : ")

    put render("vhost", binding), site_name
    sudo "mv #{site_name} /etc/apache2/sites-available/#{site_name}"
    sudo "sudo a2ensite #{site_name}"
    reload
  end
  
  desc "Delete a website (! delete all file and folders)"
  task :delete_website, :roles => :web do
    site_name = Capistrano::CLI.ui.ask("Site name you want to delete : ")
    sure = Capistrano::CLI.ui.ask("Are you sure you want to delete #{site_name} and all its files? (y/n) : ")
    if sure=="y"
      sudo "sudo a2dissite #{site_name}"
      sudo "rm /etc/apache2/sites-available/#{site_name}"
      sudo "rm -Rf /home/#{user}/websites/#{site_name}"
      reload
    end
  end
  
  desc "Fix the mod_deflate configuration and activate it"
  task :mod_deflate, :roles => :web do
    put render("deflate.conf", binding), "deflate.conf"
    sudo "mv deflate.conf /etc/apache2/mods-available/deflate.conf"
    sudo "a2enmod deflate"
    force_reload
  end
  
  desc "Setup SSL with certificate, active mod_ssl"
  task :setup_ssl, :roles => :web do
    site_name = Capistrano::CLI.ui.ask("Site name the certificate to upload is for : ")
    domain_name = Capistrano::CLI.ui.ask("Domain name the certificate to upload is for : ")
    site_file = "#{site_name}.#{domain_name}".gsub(/\./, '_')
    ssl_cert_path = "/etc/apache2/ssl"
    sudo "mkdir #{ssl_cert_path} || echo \"Directory #{ssl_cert_path} exists\""
    ["#{site_file}.crt", "#{site_file}.key", "DigiCertCA.crt"].each do |filename|
      upload File.join(default_local_files_path, filename), filename
      sudo "mv #{filename} #{ssl_cert_path}"
    end
    sudo "a2enmod ssl"
    put render("vhost_ssl", binding), "#{site_name}_ssl"
    sudo "mv #{site_name}_ssl /etc/apache2/sites-available/#{site_name}_ssl"
    sudo "sudo a2ensite #{site_name}_ssl"
    force_reload
  end
end
