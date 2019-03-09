function fzf-ghq-combo () {
  local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N fzf-ghq-combo
bindkey '^]' fzf-ghq-combo

function fzf-find-file() {
  if git rev-parse 2> /dev/null; then
      source_files=$(git ls-files)
  else
      source_files=$(find . -type f)
  fi
  BUFFER=$BUFFER$(echo $source_files | fzf --prompt "[find file]")
  CURSOR=$#BUFFER
  zle redisplay
}

zle -N fzf-find-file
bindkey '^F' fzf-find-file

function fzf-select-history() {
  BUFFER=$(fc -l -r -n 1 | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}

zle -N fzf-select-history
bindkey '^R' fzf-select-history

function fzf-git-select() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

zle -N fzf-git-select
bindkey '^G' fzf-git-select
