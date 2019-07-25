directory "#{ENV['HOME']}/.config/git"

link "#{ENV['HOME']}/.config/git/config" do
  to File.expand_path('.config/git/.gitconfig')
  force true
end

link "#{ENV['HOME']}/.config/git/ignore" do
  to File.expand_path('.config/git/.gitignore_global')
  force true
end
