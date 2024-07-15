include_recipe File.expand_path('../../../lib/recipe_helper.rb', __FILE__)

define :pacman_build, app_path: nil do
  app_name = params[:name]
  run_cmd = unless params[:app_path].nil?
              "which #{app_name}"
            else
              "test -d #{params[:app_path]}"
            end
  build_dir = "#{ENV['HOME']}/#{app_name}"

  if run_command(run_cmd, error: false).exit_status == 1
    git build_dir do
      repository "https://aur.archlinux.org/#{app_name}.git"
    end

    execute 'makepkg' do
      cwd build_dir
    end

    execute "pacman -U #{app_name}-*.pkg.tar.xz" do
      user 'root'
      cwd build_dir
    end

    execute "rm -rf #{build_dir}" do
      only_if "test -d #{build_dir}"
    end
  end
end

include_cookbook 'zsh'
include_cookbook 'tmux'
include_cookbook 'vscode'
include_cookbook 'git'
include_cookbook 'vim'
include_cookbook 'idea'
