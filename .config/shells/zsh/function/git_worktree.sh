# Worktree storage location under home
export WORKTREE_ROOT="$HOME/worktrees"

# wt — subcommands for managing git worktrees
wt() {
  local cmd="$1"

  case "$cmd" in
    add)
      shift
      _wt_add "$@"
      ;;
    ls)
      shift
      _wt_ls "$@"
      ;;
    rm)
      shift
      _wt_rm "$@"
      ;;
    cd)
      shift
      _wt_cd "$@"
      ;;
    c)
      shift
      _wt_c "$@"
      ;;
    -h|--help|help|"")
      _wt_help
      ;;
    *)
      echo "wt: unknown subcommand '$cmd'" >&2
      echo "" >&2
      _wt_help >&2
      return 1
      ;;
  esac
}

# wt --help — show usage
_wt_help() {
  cat <<'EOF'
Usage: wt <command> [args]

Commands:
  add <branch-name> [base-branch]   Create a worktree and switch to it (auto-detects existing/new branch)
  ls                                List worktrees for the current repository
  rm <branch-name> [git-args...]    Remove a worktree
  cd <branch-name>                  Switch to an existing worktree
  c <branch-name> [base-branch]     Create a worktree and launch Claude Code as a named session
  -h, --help                        Show this help

Worktrees are created at $WORKTREE_ROOT/<repo>/<branch>.
EOF
}

# wt add <branch-name> [base-branch]
# Create a worktree at ~/worktrees/<repo>/<branch> from the current repo and switch to it
_wt_add() {
  if [ -z "$1" ]; then
    echo "Usage: wt add <branch-name> [base-branch]"
    return 1
  fi

  local branch="$1"
  local base="${2:-$(git symbolic-ref --short HEAD 2>/dev/null || echo main)}"

  # Get the git repository root and repository name
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

  # Branch on whether the branch already exists
  if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$repo_root" worktree add "$wt_path" "$branch" || return 1
  else
    git -C "$repo_root" worktree add -b "$branch" "$wt_path" "$base" || return 1
  fi

  # Copy over non-tracked files that are needed (adjust as necessary)
  for f in .env .env.local; do
    [ -f "$repo_root/$f" ] && cp "$repo_root/$f" "$wt_path/$f"
  done

  cd "$wt_path" || return 1
  echo "✓ Worktree ready at $wt_path"
}

# wt ls — list worktrees for the current repository
_wt_ls() {
  git worktree list
}

# wt rm <branch-name> — remove a worktree
_wt_rm() {
  if [ -z "$1" ]; then
    echo "Usage: wt rm <branch-name>"
    return 1
  fi

  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  repo_name=$(basename "$repo_root")
  local wt_path="$WORKTREE_ROOT/$repo_name/$1"

  git -C "$repo_root" worktree remove "$wt_path" "${@:2}"
}

# wt cd <branch-name> — switch to an existing worktree
_wt_cd() {
  local repo_root repo_name
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  repo_name=$(basename "$repo_root")
  cd "$WORKTREE_ROOT/$repo_name/$1" || return 1
}

# wt c <branch-name> [base-branch]
# Create a worktree and launch Claude Code as a named session using the branch name
_wt_c() {
  _wt_add "$@" || return 1
  claude -n "$1"
}
