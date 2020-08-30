execute 'curl -sSL https://get.haskellstack.org/ | sh' do
  not_if 'which stack'
end

execute 'stack upgrade' do
  only_if 'which stack'
end
