directory "#{ENV['HOME']}/.config/nvim"

link "#{ENV['HOME']}/.config/nvim/init.lua" do
  to File.expand_path('.config/editors/nvim/init.lua')
  force true
end
