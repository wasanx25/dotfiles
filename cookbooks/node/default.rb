execute 'curl -L https://git.io/n-install | bash' do
  not_if 'which n'
end
