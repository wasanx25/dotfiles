case node[:platform]
when 'arch'
  if false # TODO which code
    git "#{ENV['HOME']}/ghq" do
      repository 'https://aur.archlinux.org/ghq.git'
    end

    execute 'makepkg' do
      cwd "#{ENV['HOME']}/ghq"
    end

    execute 'pacman -U ghq-*.pkg.tar.xz' do
      user 'root'
      cwd "#{ENV['HOME']}/ghq"
    end

    execute "rm -rf #{ENV['HOME']}/ghq" do
      only_if "test -d #{ENV['HOME']}/ghq"
    end
  end
end
