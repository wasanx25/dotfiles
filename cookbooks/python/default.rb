execute 'cat plugins.txt | xargs -L 1 pip3 install' do
  cwd File.expand_path('../files', __FILE__)
end
