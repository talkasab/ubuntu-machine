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

end
