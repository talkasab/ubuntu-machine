namespace :machine do

  desc "Allow the user to SSH"
  task :initial_setup do
    # force the non-interactive mode
    run "cat /etc/environment > ~/environment.tmp"
    run 'echo DEBIAN_FRONTEND=noninteractive >> ~/environment.tmp'
    sudo 'mv ~/environment.tmp /etc/environment'
    # prevent this env variable to be skipped by sudo
    run "echo 'Defaults env_keep = \"DEBIAN_FRONTEND\"' >> /etc/sudoers"

    run "echo 'AllowUsers #{user_to_create}' >> /etc/ssh/sshd_config"
    run "/etc/init.d/ssh reload"
  end
  
  task :configure do
    ssh.setup
    iptables.configure
    aptitude.setup
  end
  
  task :install_dev_tools do
    mysql.install
    apache.install
    ruby.install
    postfix.install
    gems.install_rubygems
    ruby.install_enterprise
    ruby.install_passenger
    git.install
    php.install
  end
  
  desc = "Ask for a user and change his password"
  task :change_password do
    user_to_update = Capistrano::CLI.ui.ask("Name of the user whose you want to update the password : ")
    
    run_and_watch_prompt("passwd #{user_to_update}", [/Enter new UNIX password/, /Retype new UNIX password:/])
  end
end
