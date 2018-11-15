case node[:platform]
when 'arch'
  package 'libcurl-gnutls'
  package 'libgnome-keyring'

  if false # TODO which code
    git "#{ENV['HOME']}/gitkraken" do
      repository 'https://aur.archlinux.org/gitkraken.git'
    end

    execute 'makepkg' do
      cwd "#{ENV['HOME']}/gitkraken"
    end

    execute 'pacman -U gitkraken-*.pkg.tar.xz' do
      user 'root'
      cwd "#{ENV['HOME']}/gitkraken"
    end

    execute "rm -rf #{ENV['HOME']}/gitkraken" do
      only_if "test -d #{ENV['HOME']}/gitkraken"
    end
  end
end
