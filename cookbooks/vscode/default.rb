execute 'cat extensions.txt | xargs -L 1 code --install-extension' do
  cwd File.expand_path('../files', __FILE__)
end

case node[:platform]
when 'darwin'
  link '/usr/local/bin' do
    to '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
    force true
  end

  link "#{ENV['HOME']}/Library/Application Support/Code/User/settings.json" do
    to File.expand_path('.config/editors/vscode/darwin/settings.json')
    force true
  end

  link "#{ENV['HOME']}/Library/Application Support/Code/User/keybindings.json" do
    to File.expand_path('.config/editors/vscode/darwin/keybindings.json')
    force true
  end
when 'arch'
  pacman_build 'visual-studio-code-bin' do
    app_path '/opt/visual-studio-code'
  end

  link "#{ENV['HOME']}/.config/Code/User/settings.json" do
    to File.expand_path('.config/editors/vscode/arch/settings.json')
    force true
  end
end
