---
name: write-plan-to-issue
description: Use when the user wants to publish an implementation plan to a GitHub issue - posts the plan to an existing issue as a comment, or creates a new issue when none exists. Triggers on "プランをissueに書く", "プランをissueに投稿", "write plan to issue", "post the plan to GitHub".
allowed-tools: Bash(gh issue:*), Bash(gh repo view:*), Bash(gh auth status:*), Bash(git remote:*), Bash(mktemp:*), Read, Glob, AskUserQuestion
---

# Write Plan to GitHub Issue

エージェントが作成した実装プランを、該当リポジトリの GitHub issue に投稿する。既存 issue があればコメントとして追記し、無ければ issue を新規作成して本文に書き込む。

## Prerequisites

- `gh` CLI がインストール済みで認証されていること
- カレントディレクトリが GitHub リモートを持つ git リポジトリであること

## Workflow

以下の 6 ステップを順に実行する。各ステップを TODO として登録して進めること。

### 1. リポジトリの確認

```bash
gh repo view --json nameWithOwner,url -q .nameWithOwner
```

失敗した場合は原因を切り分けてユーザーに報告し、**停止する**。

- GitHub リモートが無い → `git remote -v` の結果を示す
- 未認証 → `gh auth status` を実行し、`gh auth login` を案内する

以降の `gh` コマンドは、このリポジトリに対して実行する。

### 2. プラン本文の解決

次の優先順でプラン本文を決める。

1. **引数のファイルパス** — 引数が `.md` で終わる、または実在するパスなら Read で読む
2. **最新のプランファイル** — 無ければ `.mine/plans/*.md` を Glob し、更新時刻が最新のものを選ぶ。どのファイルを使ったかユーザーに明示する
3. **会話中のプラン** — ファイルが無ければ、この会話で提示済みのプランを Markdown に整形して使う

いずれも見つからない場合は「投稿するプランが見つかりません」と伝えて**停止する**。

取得後の整形:

- YAML frontmatter があれば取り除く
- 先頭の H1 見出し（無ければファイル名）からタイトル候補を作る
- タイトル候補から検索用キーワードを 2〜4 語抽出する

### 3. 対象 issue の特定

**引数に issue 指定がある場合**（`#123` / `123` / issue の URL）:

```bash
gh issue view <number> --json number,title,state,url
```

存在を確認する。`state` が `CLOSED` なら、その事実をステップ 4 の確認に必ず含める。

**引数に指定が無い場合** — タイトル候補のキーワードで既存 issue を検索する:

```bash
gh issue list --state open --limit 20 --search "<keywords>" --json number,title,url
```

- 候補があれば AskUserQuestion で選ばせる（各候補 / 新規作成 の選択肢を出す）
- 候補が無ければ新規作成モードに入る

### 4. 投稿前の確認（必須）

`gh issue create` / `gh issue comment` を実行する前に、必ず AskUserQuestion で承認を取る。提示する内容:

- **対象**: 既存 issue なら番号・タイトル・URL（closed ならその旨）、新規なら作成予定のタイトル
- **方法**: コメント追記 / 新規 issue の本文
- **プレビュー**: 投稿本文の冒頭（30 行程度）と全体の行数

承認が得られない限り、書き込み系のコマンドは**実行しない**。

### 5. 投稿

本文は必ず一時ファイル経由で渡す（クォート事故と長文の切り詰めを避けるため）。

```bash
body=$(mktemp)
# ... 本文を $body に書き出す ...

# 新規作成: プランを本文に
gh issue create --title "<title>" --body-file "$body"

# 既存 issue: コメントで追記
gh issue comment <number> --body-file "$body"

rm -f "$body"
```

本文の先頭には次のヘッダを付ける（元プランがファイル由来のときだけコメント行を入れる）:

```markdown
## 実装プラン

<!-- 元プラン: .mine/plans/xxx.md -->

（プラン本文）
```

### 6. 結果報告

`gh` が出力した issue / コメントの URL をそのままユーザーに提示する。プランの要約は不要。

## Notes

- 書き込み系コマンドは意図的に allowed-tools の広い許可に頼らず、ステップ 4 の確認を経てから実行する
- プランが長い場合でも分割せず 1 コメントで投稿する。GitHub の本文上限（65536 文字）を超える場合のみ、超過を伝えて分割の可否をユーザーに確認する
