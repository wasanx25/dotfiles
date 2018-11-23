case node[:platform]
when 'arch'
  package 'rsync'
  package 'jdk-openjdk'
  pacman_build 'goland-eap' do
    app_path '/opt/goland-eap'
  end
end
