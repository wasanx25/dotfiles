case node[:platform]
when 'arch'
  package 'libcurl-gnutls'
  package 'libgnome-keyring'

  if run_command('test -d /opt/gitkraken', error: false).exit_status == 1
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
