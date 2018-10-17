link "#{ENV['HOME']}/.gitconfig" do
  to File.expand_path('.config/git/.gitconfig')
  force true
end

link "#{ENV['HOME']}/.gitignore_global" do
  to File.expand_path('.config/git/.gitignore_global')
  force true
end
