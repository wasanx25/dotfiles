execute 'curl -o n-install.sh -L https://git.io/n-install && yes | bash n-install.sh && rm n-install.sh' do
  not_if 'which n'
end
