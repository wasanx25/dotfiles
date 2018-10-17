execute 'curl https://sh.rustup.rs -sSf | sh' do
  not_if 'rustc -V'
end

execute 'rustup component add rust-src' do
  not_if "test -d #{ENV['HOME']}/.multirust"
end