include_recipe File.expand_path('../../../lib/recipe_helper.rb', __FILE__)

include_cookbook 'brew'
include_cookbook 'zsh'
include_cookbook 'tmux'
include_cookbook 'vscode'
include_cookbook 'git'
include_cookbook 'vim'
include_cookbook 'starship'

###
# install languages
###
# include_cookbook 'python'
# include_cookbook 'haskell'
# include_cookbook 'rust'
# include_cookbook 'node'
