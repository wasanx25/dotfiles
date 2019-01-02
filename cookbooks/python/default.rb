execute 'pip3 install -r requirements.txt' do
  cwd File.expand_path('../files', __FILE__)
end
