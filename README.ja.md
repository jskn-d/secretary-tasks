# Secretary Tasks

[English](README.md)

macOS 用の軽量フローティングパネルアプリ。Markdown ベースの Todo ファイルを監視し、リアルタイムで表示します。

## 機能

- **フローティングパネル** — 常に最前面に表示、すべてのスペースで利用可能
- **グローバルホットキー** — `⌃⌥S`（Control + Option + S）で表示/非表示を切り替え
- **ファイル監視** — Todo ファイルの変更をリアルタイムで自動反映
- **セクション分け** — Markdown の見出しでタスクをグループ化
- **ディスパッチプレビュー** — 選択したタスクのリンク先をサイドパネルに表示
- **日付ロールオーバー** — 日付が変わると自動的に新しい日のファイルに切り替え

## 動作要件

- macOS 13.0+
- Swift 5.9+
- Xcode Command Line Tools

## インストール

```bash
git clone https://github.com/jskn-d/secretary-tasks.git
cd secretary-tasks
./install.sh
```

インストールスクリプトがリリースビルドを行い、`~/Applications/SecretaryTasks.app` を作成します。

初回インストール時はアクセシビリティ権限の許可が必要です:
**システム設定 > プライバシーとセキュリティ > アクセシビリティ > SecretaryTasks をON**

## 設定

メニューバーのアイコンから **Settings...** を選択して、ディレクトリパスを設定できます。

設定は `~/.config/secretary-tasks/config.json` に保存されます。手動で編集することも可能です。

```json
{
  "secretaryBaseDirectory": "~/path/to/your/.secretary"
}
```

| キー | 説明 | デフォルト |
|------|------|-----------|
| `secretaryBaseDirectory` | `todos/` フォルダとリンクファイルを含むルートディレクトリ | `~/.secretary` |

設定ファイルが存在しない場合は `~/.secretary` が使用されます。

## Todo ファイルのフォーマット

Todo ファイルは `<secretaryBaseDirectory>/todos/` に日付名（`YYYY-MM-DD.md`）で保存する Markdown ファイルです。

```markdown
# 2026-03-21

## 仕事

- [ ] PRレビュー
- [x] ステージングデプロイ
- [ ] API ドキュメント作成 → dispatches/api-docs.md

## プライベート

- [ ] 買い物
- [ ] 歯医者に電話
```

### 記法

- `## 見出し` — セクションを作成
- `- [ ] タスク` — 未完了タスク
- `- [x] タスク` — 完了タスク
- `→ path/to/file.md` — ディスパッチファイルへのリンク（選択時にサイドパネルに表示）。パスは `secretaryBaseDirectory` からの相対パス。

## ライセンス

[MIT](LICENSE)
