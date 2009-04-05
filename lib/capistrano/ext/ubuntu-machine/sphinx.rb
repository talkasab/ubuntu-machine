namespace :sphinx do
  desc "Install sphinx"
  task :install, :roles => :app do
    sphinx_version = "sphinx-0.9.8.1"
    run "wget -nv http://www.sphinxsearch.com/downloads/#{sphinx_version}.tar.gz"
    run "tar xvzf #{sphinx_version}.tar.gz"
    run "cd #{sphinx_version}"
    run "cd #{sphinx_version} && ./configure"
    run "cd #{sphinx_version} && make"
    run "cd #{sphinx_version} && sudo make install"
    run "rm #{sphinx_version}.tar.gz"
    run "rm -Rf #{sphinx_version}"
  end

end
