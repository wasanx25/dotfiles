# dotfiles

## start

requirements:

- Mac
  - Apple ID Sign in

```
$ curl -L https://raw.githubusercontent.com/wasanx25/dotfiles/master/bootstrap.sh | sh
```

## update

```
$ bin/mitame-${version} local lib/recipe.rb
```

## others

### git config

use git hooks cloned repositories

```
$ ghq list | grep [ORG NAME] | xargs -I {} cp ~/.config/git/templates/hooks/pre-push "$(ghq root)/{}/.git/hooks/pre-push"
```
