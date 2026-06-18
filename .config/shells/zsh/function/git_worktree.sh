# ホーム配下のworktree置き場
export WORKTREE_ROOT="$HOME/worktrees"

# wt <branch-name> [base-branch]
# カレントリポジトリから ~/worktrees/<repo>/<branch> にworktreeを作って移動
wt() {
  if [ -z "$1" ]; then
    echo "Usage: wt <branch-name> [base-branch]"
    return 1
  fi

  local branch="$1"
  local base="${2:-$(git symbolic-ref --short HEAD 2>/dev/null || echo main)}"

  # gitリポジトリのルートとリポジトリ名を取得
  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Not in a git repository"
    return 1
  }
  repo_name=$(basename "$repo_root")

  local wt_path="$WORKTREE_ROOT/$repo_name/$branch"

  if [ -d "$wt_path" ]; then
    echo "Worktree already exists, switching to it: $wt_path"
    cd "$wt_path" || return 1
    return 0
  fi

  mkdir -p "$WORKTREE_ROOT/$repo_name"

  # 既存ブランチかどうかで分岐
  if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$repo_root" worktree add "$wt_path" "$branch" || return 1
  else
    git -C "$repo_root" worktree add -b "$branch" "$wt_path" "$base" || return 1
  fi

  # git管理外の必要ファイルをコピー(必要に応じて調整)
  for f in .env .env.local; do
    [ -f "$repo_root/$f" ] && cp "$repo_root/$f" "$wt_path/$f"
  done

  cd "$wt_path" || return 1
  echo "✓ Worktree ready at $wt_path"
}

# wtls — 現在のリポジトリのworktree一覧
wtls() {
  git worktree list
}

# wtrm <branch-name> — worktreeを削除
wtrm() {
  if [ -z "$1" ]; then
    echo "Usage: wtrm <branch-name>"
    return 1
  fi

  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  repo_name=$(basename "$repo_root")
  local wt_path="$WORKTREE_ROOT/$repo_name/$1"

  git -C "$repo_root" worktree remove "$wt_path" "${@:2}"
}

# wtcd <branch-name> — 既存worktreeに移動
wtcd() {
  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  repo_name=$(basename "$repo_root")
  cd "$WORKTREE_ROOT/$repo_name/$1" || return 1
}

# wtc <branch-name> [base-branch]
# worktreeを作って Claude Code をブランチ名でnamed sessionとして起動
wtc() {
  wt "$@" || return 1
  claude -n "$1"
}
