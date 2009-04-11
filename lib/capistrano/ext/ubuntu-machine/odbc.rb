namespace :odbc do
  desc "Install ODBC/FreeTDS"
  task :install, :roles => :app do
    run "cp /etc/profile ~/profile.tmp"
    run "echo 'export ODBCINI=/etc/odbc.ini' >> ~/profile.tmp"
    run "echo 'export ODBCSYSINI=/etc' >> ~/profile.tmp"
    run "echo 'export FREETDSCONF=/etc/freetds/freetds.conf' >> ~/profile.tmp"
    sudo "mv ~/profile.tmp /etc/profile"    

    freetds = "freetds-0.82"
    sudo "sudo apt-get install unixodbc unixodbc-dev tdsodbc -y"
    run "wget -nv ftp://ftp.ibiblio.org/pub/Linux/ALPHA/freetds/stable/#{freetds}.tar.gz"
    run "tar xvzf #{freetds}.tar.gz"
    run "cd #{freetds}"
    run "cd #{freetds} && ./configure"
    run "cd #{freetds} && make"
    run "cd #{freetds} && sudo make install"
    run "rm #{freetds}.tar.gz"
    run "rm -Rf #{freetds}"
  end
  
  desc "Install the ruby ODBC library"
  task :install_rubyodbc, :roles => :app do
    rubyodbc = "ruby-odbc-0.9996"
    run "wget -nv http://www.ch-werner.de/rubyodbc/#{rubyodbc}.tar.gz"
    run "tar xvzf #{rubyodbc}.tar.gz"
    run "cd #{rubyodbc}"
    run "cd #{rubyodbc} && ruby extconf.rb"
    run "cd #{rubyodbc} && make"
    run "cd #{rubyodbc} && sudo make install"
    run "rm #{rubyodbc}.tar.gz"
    run "rm -Rf #{rubyodbc}"
  end

  desc "Install FreeTDS/ODBC configuration files"
  task :config_files, :roles => :app do
    put render("odbc.ini", binding), "odbc.ini"
    sudo "mv odbc.ini /etc/odbc.ini"
    put render("odbcinst.ini", binding), "odbcinst.ini"
    sudo "mv odbcinst.ini /etc/odbcinst.ini"
    put render("freetds.conf", binding), "more_freetds.conf"
    run "cat /etc/freetds/freetds.conf more_freetds.conf > freetds.conf"
    sudo "mv freetds.conf /etc/freetds/freetds.conf"
    run "rm more_freetds.conf"
  end
end
