link '/usr/local/bin' do
  to '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
end

execute 'cat extensions.txt | xargs -L 1 code --install-extension' do
  cwd File.expand_path('../files', __FILE__)
end

link "#{ENV['HOME']}/Library/Application Support/Code/User/settings.json" do
  to File.expand_path('.config/editors/vscode/settings.json')
  force true
end
