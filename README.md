# dotfiles

## start

requirements:

- Mac
  - Apple ID Sign in

```
$ curl -sSfL https://raw.githubusercontent.com/wasanx25/dotfiles/master/bootstrap.sh | sh
```

## update

```
$ bin/mitame-${version} local lib/recipe.rb
```

or

specific cookbook

```
$ bin/mitame-${version} local cookbooks/${cookbook_name}/recipe.rb
```

## others

### git config

use git hooks cloned repositories

```
$ ghq list | grep [ORG NAME] | xargs -I {} cp ~/.config/git/templates/hooks/pre-push "$(ghq root)/{}/.git/hooks/pre-push"
```
