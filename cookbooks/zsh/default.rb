link "#{ENV['HOME']}/.zshrc" do
  to File.expand_path('.config/shells/zsh/.zshrc')
  force true
end

link "#{ENV['HOME']}/oh-my-zsh" do
  to File.expand_path('.config/shells/zsh/oh-my-zsh')
  force true
end

link "#{ENV['HOME']}/zshfuns" do
  to File.expand_path('.config/shells/zsh/function')
  force true
end