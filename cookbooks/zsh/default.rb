link "#{ENV['HOME']}/.zshrc" do
  to File.expand_path('.config/shells/zsh/.zshrc')
  force true
end

git "#{ENV['HOME']}/oh-my-zsh" do
  repository 'https://github.com/robbyrussell/oh-my-zsh.git'
end

link "#{ENV['HOME']}/zshfuns" do
  to File.expand_path('.config/shells/zsh/function')
  force true
end

execute "/bin/zsh -c \"source #{ENV['HOME']}/.zshrc\""