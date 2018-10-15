execute 'curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install' do
  not_if 'which brew'
end

execute 'brew bundle' do
  cwd File.expand_path('../files', __FILE__)
end