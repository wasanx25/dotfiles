# =====================================================================
# clasp-deploy : 指定 HTML を Google Apps Script の Web アプリとして
#                アップロード(push) → デプロイ(deploy) → 公開(組織内のみ = DOMAIN)
#
# 使い方:  clasp-deploy <path/to/file.html> ["デプロイの説明"]
#
# 事前準備:
#   1) Node.js v20+ / npm i -g @google/clasp
#   2) clasp login
#   3) https://script.google.com/home/usersettings で
#      "Google Apps Script API" を ON
#
# 環境変数で上書き可:
#   CLASP_PROJECTS_HOME      プロジェクトの管理ルート   (default: ~/clasp-projects)
#   CLASP_PROJECT_NAME       プロジェクト名(サブdir名)  (default: HTMLのファイル名/拡張子なし)
#   CLASP_PROJECT_DIR        プロジェクトdirを直接指定  (上の2つより優先。指定時はそのパスを使用)
#   CLASP_SCRIPT_TITLE       GAS上のプロジェクト名       (default: HTMLのファイル名/拡張子なし)
#   CLASP_TIMEZONE           タイムゾーン               (default: Asia/Tokyo)
#   CLASP_WEBAPP_ACCESS      MYSELF/DOMAIN/ANYONE/ANYONE_ANONYMOUS
#                            (default: DOMAIN = 組織内のみ)
#   CLASP_WEBAPP_EXECUTE_AS  USER_DEPLOYING / USER_ACCESSING (default: USER_DEPLOYING)
# =====================================================================
clasp-deploy() {
  emulate -L zsh   # この関数内だけ素の zsh 挙動にして、ユーザー設定の影響を避ける

  # ---- ヘルプ ----
  if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    cat <<'USAGE'
clasp-deploy <path/to/file.html> ["デプロイの説明"]

  指定 HTML を GAS の Web アプリとして push → deploy し、組織内のみ公開します。

  事前準備:
    1) Node.js v20+ / npm i -g @google/clasp
    2) clasp login
    3) script.google.com の設定で "Google Apps Script API" を ON

  環境変数:
    CLASP_PROJECTS_HOME      管理ルート                (default: ~/clasp-projects)
    CLASP_PROJECT_NAME       プロジェクト名(サブdir)   (default: HTMLのファイル名)
    CLASP_PROJECT_DIR        dirを直接指定(最優先)
    CLASP_SCRIPT_TITLE       GAS上のプロジェクト名     (default: HTMLのファイル名)
    CLASP_TIMEZONE           タイムゾーン              (default: Asia/Tokyo)
    CLASP_WEBAPP_ACCESS      公開範囲                  (default: DOMAIN = 組織内のみ)
    CLASP_WEBAPP_EXECUTE_AS  実行ユーザー              (default: USER_DEPLOYING)
USAGE
    return 0
  fi

  # ---- 引数 ----
  local html_src="$1"
  local deploy_desc="${2:-Deployed at $(date '+%Y-%m-%d %H:%M:%S')}"

  # ---- 設定(環境変数で上書き可) ----
  local script_title="${CLASP_SCRIPT_TITLE:-${html_src:t:r}}"
  local timezone="${CLASP_TIMEZONE:-Asia/Tokyo}"
  local webapp_access="${CLASP_WEBAPP_ACCESS:-DOMAIN}"
  local webapp_execute_as="${CLASP_WEBAPP_EXECUTE_AS:-USER_DEPLOYING}"
  local entry_file="index"

  # プロジェクトは ~/clasp-projects 配下で管理する
  #   project_name : CLASP_PROJECT_NAME 指定があればそれ / なければ HTML のファイル名(拡張子なし)
  #   project_dir  : CLASP_PROJECT_DIR を明示した場合はそのパスを最優先で使う
  local projects_home="${CLASP_PROJECTS_HOME:-$HOME/clasp-projects}"
  local project_name="${CLASP_PROJECT_NAME:-${html_src:t:r}}"
  local project_dir="${CLASP_PROJECT_DIR:-$projects_home/$project_name}"

  # ---- 事前チェック(ここで return すれば対話シェルは死なない) ----
  if [[ ! -f "$html_src" ]]; then
    print -u2 "Error: HTML ファイルが見つかりません: $html_src"
    return 1
  fi
  if ! command -v clasp >/dev/null 2>&1; then
    print -u2 "Error: clasp が見つかりません。'npm i -g @google/clasp' を実行してください。"
    return 1
  fi
  if [[ ! -f "$HOME/.clasprc.json" ]]; then
    print -u2 "Error: clasp 未ログインです。'clasp login' を実行してください。"
    return 1
  fi

  # cd する前に絶対パス化 (:A = 絶対パスへ正規化する zsh の修飾子)
  local html_abs="${html_src:A}"

  # ---- 本処理はサブシェルに閉じ込める ----
  # set -e / cd が対話シェルに漏れない & カレントディレクトリも動かない
  (
    set -euo pipefail

    mkdir -p "$project_dir"
    cd "$project_dir"
    echo ">> プロジェクトの場所: $project_dir"

    # プロジェクト作成 or 再利用
    if [[ ! -f ".clasp.json" ]]; then
      echo ">> 新しい Apps Script プロジェクトを作成します..."
      clasp create --type standalone --title "$script_title"
    else
      echo ">> 既存プロジェクトを再利用します (.clasp.json あり)"
    fi

    # 渡された HTML を index.html として配置
    cp "$html_abs" "${entry_file}.html"

    # doGet で HTML を返すサーバーコード
    cat > Code.js <<EOF
function doGet() {
  return HtmlService.createHtmlOutputFromFile('${entry_file}')
    .setTitle('${script_title}')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1');
}
EOF

    # マニフェスト(Web アプリ設定 = 組織内のみ公開)
    cat > appsscript.json <<EOF
{
  "timeZone": "${timezone}",
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8",
  "webapp": {
    "access": "${webapp_access}",
    "executeAs": "${webapp_execute_as}"
  }
}
EOF

    echo ">> コードをアップロード (clasp push)..."
    clasp push -f

    # デプロイ(2回目以降は同じデプロイを更新 → URL 不変)
    id_file=".deployment-id"
    deployment_id=""
    if [[ -s "$id_file" ]]; then
      deployment_id="$(cat "$id_file")"
      echo ">> 既存デプロイを更新します (URL 不変): $deployment_id"
      clasp deploy -i "$deployment_id" -d "$deploy_desc"
    else
      echo ">> 新規デプロイを作成します..."
      out="$(clasp deploy -d "$deploy_desc")"
      echo "$out"
      deployment_id="$(printf '%s\n' "$out" | grep -oE 'AKfycb[0-9A-Za-z_-]+' | head -n1 || true)"
      [[ -n "$deployment_id" ]] && printf '%s' "$deployment_id" > "$id_file"
    fi

    echo ""
    echo "==================================================================="
    echo " デプロイ完了  (公開範囲: ${webapp_access} = 組織内のみ)"
    if [[ -n "$deployment_id" ]]; then
      echo " Deployment ID : ${deployment_id}"
      echo " Web App URL   : https://script.google.com/macros/s/${deployment_id}/exec"
      echo "   ドメイン明示版: https://script.google.com/a/macros/<your-domain>/s/${deployment_id}/exec"
    else
      echo " deployment ID を取得できませんでした。'cd ${project_dir} && clasp deployments' で確認してください。"
    fi
    echo "==================================================================="
  )
}
