case node[:platform]
when 'arch'
  package 'libcurl-gnutls'
  package 'libgnome-keyring'
  pacman_build 'gitkraken' do
    app_path '/opt/gitkraken'
  end
end
