execute 'curl -fsSL https://starship.rs/install.sh | bash' do
  not_if 'which starship'
end

link "#{ENV['HOME']}/.config/starship.toml" do
  to File.expand_path('.config/starship/starship.toml')
  force true
end
