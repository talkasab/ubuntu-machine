namespace :beanstalk do
  desc "Install beanstalkd"
  task :install, :roles => :web do
    libevent = "libevent-1.4.10-stable"
    libevent_url = "http://monkey.org/~provos/#{libevent}.tar.gz"
    beanstalkd = "beanstalkd-1.3"
    beanstalkd_url = "http://xph.us/dist/beanstalkd/#{beanstalkd}.tar.gz"

    run "wget -nv #{libevent_url}"
    run "tar xvzf #{libevent}.tar.gz"
    run "cd #{libevent}"
    run "cd #{libevent} && ./configure"
    run "cd #{libevent} && make"
    run "cd #{libevent} && sudo make install"
    run "rm #{libevent}.tar.gz"
    run "rm -Rf #{libevent}"

    run "wget -nv #{beanstalkd_url}"
    run "tar xvzf #{beanstalkd}.tar.gz"
    run "cd #{beanstalkd}"
    run "cd #{beanstalkd} && LD_LIBRARY_PATH=/usr/local/lib ./configure"
    run "cd #{beanstalkd} && LD_LIBRARY_PATH=/usr/local/lib make"
    run "cd #{beanstalkd} && sudo LD_LIBRARY_PATH=/usr/local/lib make install"
    run "rm #{beanstalkd}.tar.gz"
    run "rm -Rf #{beanstalkd}"
  end
end