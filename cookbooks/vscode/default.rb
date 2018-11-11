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
when 'arch'
  if false # TODO which code
    git "#{ENV['HOME']}/visual-studio-code-bin" do
      repository 'https://aur.archlinux.org/visual-studio-code-bin.git'
    end

    excute 'makepkg -S' do
      cwd "#{ENV['HOME']}/visual-studio-code-bin"
    end

    excute 'pacman -U visual-studio-code-bin-*.pkg.tar.xz' do
      cwd "#{ENV['HOME']}/visual-studio-code-bin"
    end
  end

  link "#{ENV['HOME']}/.config/Code/User/settings.json" do
    to File.expand_path('.config/editors/vscode/arch/settings.json')
    force true
  end
end
