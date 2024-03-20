link "#{ENV['HOME']}/.vimrc" do
  to File.expand_path('.config/editors/vim/.vimrc')
  force true
end

# TODO: must skip prompt
# execute 'curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh'
# execute 'sh ./installer.sh ~/.cache/dein'
# execute 'rm ./installer.sh'

directory "#{ENV['HOME']}/.vim"

link "#{ENV['HOME']}/.vim/dein.toml" do
  to File.expand_path('.config/editors/vim/dein.toml')
  force true
end
