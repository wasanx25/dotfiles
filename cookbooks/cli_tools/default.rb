define :install_cli_tools do
  execute "brew install #{params[:name]}" do
    not_if "which #{params[:name]}"
  end

  execute "brew upgrade #{params[:name]}" do
    only_if "which #{params[:name]}"
  end
end

install_cli_tools 'ag' 		 # https://github.com/ggreer/the_silver_searcher
install_cli_tools 'bat' 	 # https://github.com/sharkdp/bat
install_cli_tools 'dust'   # https://github.com/bootandy/dust
install_cli_tools 'fzf' 	 # https://github.com/junegunn/fzf
install_cli_tools 'ghq' 	 # https://github.com/x-motemen/ghq
install_cli_tools 'procs'  # https://github.com/dalance/procs
install_cli_tools 'pstree' # https://github.com/tmm1/pstree
