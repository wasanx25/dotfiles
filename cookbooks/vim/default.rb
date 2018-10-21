directory "#{ENV['HOME']}/.vim/bundle/neobundle.vim"

git "#{ENV['HOME']}/.vim/bundle/neobundle.vim" do
  repository 'https://github.com/Shougo/neobundle.vim'
end

link "#{ENV['HOME']}/.vimrc" do
  to File.expand_path('.config/editors/vim/.vimrc')
  force true
end