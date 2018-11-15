case node[:platform]
when 'arch'
  pacman_build 'ghq'
end
