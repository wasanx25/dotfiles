---
name: to-html
description: 直近のセッションで扱った内容（調査結果・レビュー観点・実装まとめ等）を、単一の自己完結 HTML ファイルに書き出す。「HTML にして」「HTML にまとめて」と言われたらこれ。
argument-hint: "[<topic-slug>] [--out <path>]"
---

# to-html

## いつ使うか

ユーザが以下のように「HTML 化」を指示したときに自動で発火する:

- 「調査した内容を HTML にまとめて」
- 「レビューすべき内容を HTML にまとめて」
- 「実装した点について HTML にまとめて」
- 「これを HTML にして」「HTML 化して」
- 「報告用に HTML が欲しい」

**目的**: 直近のセッションで Claude が積み上げたコンテキスト（調査・分析・レビュー・実装説明）を、Slack や PR で共有しやすい単一 HTML にまとめる。Markdown を経由しなくてよい。**既存 md ファイルが引数として渡された場合は md → html の変換に振る舞いを切り替える**（後述）。

## 原則

1. **入力はセッションコンテキスト**: 既に会話で確定した内容を HTML にする。改めて調査し直さない
2. **出力は自己完結の単一 .html**: インライン CSS、外部 JS / CDN 依存ゼロ。ダブルクリックでブラウザに表示できる
3. **保存先は gitignore された場所をデフォルトに**: 多くのプロジェクトで安全な `tmp/<topic>-<YYYYMMDD>.html` を第一候補とする（後述「保存先決定ルール」）
4. **何度でも上書き可**: 同一セッションで追記要望が来たら同じファイルを更新する
5. **新規 md ファイルは作らない**: ユーザが明示的に「md でも欲しい」と言わない限り html だけ出す

## 振る舞いの分岐

| 入力 | 振る舞い |
|---|---|
| 引数なし or `<topic-slug>` のみ | **session-summary モード**: 直近の会話を要約・整形して HTML 生成 |
| 既存 `.md` ファイルパスが引数 | **md-to-html モード**: その md を読み、構造を保ったまま HTML に変換 |
| `--out <path>` | 出力パスを上書き |

## 保存先決定ルール

リポジトリ / ディレクトリの状況によって、以下の優先順で保存先を決める:

1. `--out` 指定があればそれに従う
2. カレントが git リポジトリで、`tmp/` が既に存在 or `.gitignore` で `tmp/` が無視されている → `tmp/<topic>-<YYYYMMDD>.html`
3. git リポジトリだが `tmp/` が使えない → `.gitignore` を読んで無視対象のディレクトリ（例: `out/`, `.cache/`, `dist/`）があればその下に
4. 上記いずれも該当しない、または非 git ディレクトリ → カレント直下 `./<topic>-<YYYYMMDD>.html` を提案し、`AskUserQuestion` で確認

**`docs/` 直下や `README.md` の近くなど、コミット対象になりがちな場所には書かない**。リポジトリ汚染を避ける。

## 処理手順

### Step 1. 引数解釈とモード判定

1. 引数が既存ファイル (`.md` 拡張子) なら **md-to-html モード**
2. それ以外は **session-summary モード**
3. `<topic-slug>` 未指定なら、会話の主題から kebab-case で 2-3 案を `AskUserQuestion` で確認
    - 例: 調査内容 → `xxx-investigation`、レビュー → `pr-1234-review`、実装まとめ → `xxx-impl-summary`
4. 出力先は「保存先決定ルール」に従い決定

### Step 2. コンテンツ構造の決定

会話の主題に応じて、以下から適切な構造を選ぶ（複合可）:

#### 調査まとめ (investigation)
```
1. 目的・背景
2. 調査対象 (ファイル / 関数 / テーブル / API 等)
3. 主要な発見 (太字・コードリンク付き)
4. 補足情報・関連箇所
5. 残課題 / open questions
```

#### レビューまとめ (review)
```
1. レビュー対象 (PR # / ブランチ / コミット範囲 / ファイル群)
2. 重大度別の指摘 (Critical / High / Medium / Low / Nit)
3. 指摘ごと: ファイル:行 / 現状コード / 提案 / 理由
4. 良かった点
5. 総評
```

#### 実装まとめ (implementation)
```
1. 何を実装したか (1-2 行サマリ)
2. 変更ファイル一覧 (path:line / 役割)
3. 主要な変更点の説明
4. テストの追加・修正点
5. 動作確認・残タスク
```

セッションの内容に合わなければ自由に構造を組んでよい。**「とりあえず h2 が並ぶだけ」のフラットな構造は避け、目次から各セクションに飛べる形にする**。

### Step 3. HTML テンプレートで描画

以下を骨格にする（インライン CSS、依存ゼロ）。プロジェクト固有の語彙はテンプレに含めない:

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>{{タイトル}}</title>
  <style>
    :root {
      --bg: #ffffff;
      --text: #1f2328;
      --muted: #6e7781;
      --border: #d0d7de;
      --accent: #0969da;
      --code-bg: #f6f8fa;
      --critical: #cf222e;
      --high: #d1242f;
      --medium: #bf8700;
      --low: #1f883d;
      --nit: #6e7781;
      --note-bg: #ddf4ff;
      --warn-bg: #fff8c5;
      --danger-bg: #ffebe9;
    }
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Hiragino Sans", "Helvetica Neue", Arial, sans-serif; color: var(--text); background: var(--bg); line-height: 1.7; max-width: 960px; margin: 2rem auto; padding: 0 1.5rem; }
    h1 { border-bottom: 2px solid var(--border); padding-bottom: 0.4rem; }
    h2 { border-bottom: 1px solid var(--border); padding-bottom: 0.3rem; margin-top: 2.5rem; }
    h3 { margin-top: 1.8rem; }
    code { background: var(--code-bg); padding: 0.15em 0.4em; border-radius: 4px; font-size: 0.9em; font-family: "SF Mono", Menlo, Consolas, monospace; }
    pre { background: var(--code-bg); padding: 1rem; border-radius: 6px; overflow-x: auto; }
    pre code { background: transparent; padding: 0; }
    table { border-collapse: collapse; width: 100%; margin: 1rem 0; }
    th, td { border: 1px solid var(--border); padding: 0.5rem 0.8rem; text-align: left; vertical-align: top; }
    th { background: var(--code-bg); }
    a { color: var(--accent); text-decoration: none; }
    a:hover { text-decoration: underline; }
    .toc { background: var(--code-bg); border: 1px solid var(--border); border-radius: 6px; padding: 1rem 1.5rem; margin: 1.5rem 0; }
    .toc ul { margin: 0.3rem 0; padding-left: 1.2rem; }
    .badge { display: inline-block; padding: 0.1rem 0.5rem; border-radius: 12px; font-size: 0.78em; font-weight: 600; color: #fff; }
    .badge.critical { background: var(--critical); }
    .badge.high { background: var(--high); }
    .badge.medium { background: var(--medium); }
    .badge.low { background: var(--low); }
    .badge.nit { background: var(--nit); }
    .callout { border-left: 4px solid var(--accent); background: var(--note-bg); padding: 0.8rem 1rem; margin: 1rem 0; border-radius: 0 6px 6px 0; }
    .callout.warn { border-color: #bf8700; background: var(--warn-bg); }
    .callout.danger { border-color: var(--critical); background: var(--danger-bg); }
    .meta { color: var(--muted); font-size: 0.9em; }
    .filepath { font-family: "SF Mono", Menlo, Consolas, monospace; font-size: 0.85em; color: var(--muted); }
  </style>
</head>
<body>
  <h1>{{タイトル}}</h1>
  <p class="meta">生成日: {{YYYY-MM-DD}}{{ブランチがあれば: / ブランチ: <code>{{branch}}</code>}}</p>

  <nav class="toc">
    <strong>目次</strong>
    <ul>
      <li><a href="#section-1">セクション1</a></li>
      ...
    </ul>
  </nav>

  <h2 id="section-1">セクション1</h2>
  ...
</body>
</html>
```

メタ情報のブランチ表示は **git リポジトリのときだけ** 添える（`git rev-parse --abbrev-ref HEAD`）。非 git なら生成日のみ。

### Step 4. 内容を埋める

- **コード片**: `<pre><code>...</code></pre>`。HTML エスケープ（`<` → `&lt;`、`>` → `&gt;`、`&` → `&amp;`）を忘れない
- **ファイル参照**: `<code class="filepath">path/to/file.ext:42</code>` の形でコピペしやすく
- **重大度バッジ**: レビューモードでは `<span class="badge critical">Critical</span>` を見出しの隣に置く
- **注意喚起**: 重要事項は `<div class="callout warn">…</div>` で囲む。危険は `callout danger`、補足は素の `callout`
- **テーブル**: 比較・一覧は積極的に `<table>` 化する（Slack で貼ったときの可読性が段違い）
- **目次**: h2 が 3 つ以上ある場合は冒頭の `<nav class="toc">` に列挙してアンカーリンク

### Step 5. 保存と報告

1. `Write` で決定済みのパスに書き出す
2. ユーザには **絶対パスではなく相対パス**（カレントからの）を返す
3. ブラウザで開くコマンドを添える: `open <path>`（macOS）/ `xdg-open <path>`（Linux）/ `start <path>`（Windows）— OS は環境に合わせる
4. md は作らない（指示がない限り）

## やってはいけないこと

- ❌ **新規調査・実装の追加**: HTML 化指示時点で既に確定した内容のみ。「ついでに○○も調べた」は別タスク
- ❌ **外部 CDN / JS 依存**: Tailwind CDN、highlight.js、Chart.js 等は使わない。インライン CSS のみ
- ❌ **コミット対象になりがちな場所への書き出し**: `docs/`、リポジトリのルート直下、`README` 近傍など
- ❌ **マークダウン併産**: ユーザが明示的に求めない限り .md は作らない
- ❌ **絵文字の多用**: 重大度バッジで色情報は表現できる。装飾としての絵文字は付けない
- ❌ **意味のない長文化**: 会話で出た情報以上を「補足」と称して膨らませない

## チェックリスト（書き出し前）

- [ ] 単一 .html ファイルで開いて表示が崩れないか（mental simulation で OK）
- [ ] コード片の `<` `>` `&` がエスケープされているか
- [ ] ファイル参照が `path:line` 形式で書かれているか
- [ ] h2 が 3 つ以上あるなら目次があるか
- [ ] 重大度・警告レベルが badge / callout で視覚化されているか
- [ ] 出力先が gitignore 対象 / 明示指定の場所か（コミット対象を汚していないか）

## 参考: 出力例の骨格

レビューまとめの例:

```html
<h2 id="critical">Critical 指摘</h2>
<h3><span class="badge critical">Critical</span> N+1 クエリ — <code class="filepath">app/controllers/reports_controller.rb:42</code></h3>
<p><strong>現状</strong>: <code>Report.all.each { |r| r.user.name }</code> で N+1 が発生</p>
<p><strong>提案</strong>: <code>Report.includes(:user)</code> でプリロード</p>
<p><strong>理由</strong>: 100 件で 101 クエリ。本番では P95 を悪化させる</p>
```

実装まとめの例:

```html
<h2 id="changes">変更点</h2>
<table>
  <thead><tr><th>ファイル</th><th>役割</th></tr></thead>
  <tbody>
    <tr>
      <td><code class="filepath">src/services/export.ts</code></td>
      <td>出力列をフラグに応じてゲート</td>
    </tr>
  </tbody>
</table>
```

## ユーザの入力

$ARGUMENTS
