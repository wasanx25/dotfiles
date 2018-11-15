case node[:platform]
when 'arch'
  if false # TODO which code
    git "#{ENV['HOME']}/ghq" do
      repository 'https://aur.archlinux.org/ghq.git'
    end

    execute 'makepkg -S' do
      cwd "#{ENV['HOME']}/ghq"
    end

    execute 'pacman -U ghq-*.pkg.tar.xz' do
      cwd "#{ENV['HOME']}/ghq"
    end
  end
end
