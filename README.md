# Secretary Tasks

[日本語](README.ja.md)

A lightweight macOS floating panel app that displays your daily todo list. It watches Markdown-based todo files and updates in real time.

## Features

- **Floating panel** — always-on-top window that stays visible across spaces
- **Global hotkey** — toggle visibility with `⌃⌥S` (Control + Option + S)
- **Live file watching** — automatically reloads when todo files change on disk
- **Section-based layout** — tasks are grouped by Markdown headings
- **Dispatch preview** — side panel shows linked content for the selected task
- **Date rollover** — automatically switches to the new day's file at midnight

## Requirements

- macOS 13.0+
- Swift 5.9+
- Xcode Command Line Tools

## Installation

```bash
git clone https://github.com/jskn-d/secretary-tasks.git
cd secretary-tasks
./install.sh
```

The install script builds a release binary and creates `~/Applications/SecretaryTasks.app`.

On first install, you will need to grant Accessibility permission:
**System Settings > Privacy & Security > Accessibility > SecretaryTasks ON**

## Configuration

Secretary Tasks reads its configuration from `~/.config/secretary-tasks/config.json`.

```json
{
  "secretaryBaseDirectory": "~/path/to/your/.secretary"
}
```

| Key | Description | Default |
|-----|-------------|---------|
| `secretaryBaseDirectory` | Root directory containing the `todos/` folder and linked files | `~/.secretary` |

If no config file exists, the app uses `~/.secretary` as the base directory.

## Todo File Format

Todo files are Markdown files stored in `<secretaryBaseDirectory>/todos/` and named by date (`YYYY-MM-DD.md`).

```markdown
# 2026-03-21

## Work

- [ ] Review pull requests
- [x] Deploy staging build
- [ ] Write API docs → dispatches/api-docs.md

## Personal

- [ ] Buy groceries
- [ ] Call dentist
```

### Syntax

- `## Heading` — creates a section
- `- [ ] Task` — unchecked task
- `- [x] Task` — completed task
- `→ path/to/file.md` — links a dispatch file (shown in the side panel when selected). The path is relative to `secretaryBaseDirectory`.

## Customizing the Hotkey

The default hotkey is `⌃⌥S` (Control + Option + S). To change it, edit the `isHotKey` method in `Sources/SecretaryTasks/App/AppDelegate.swift`:

```swift
private static func isHotKey(_ event: NSEvent) -> Bool {
    guard event.keyCode == 1 else { return false }  // 1 = "S" key
    let mods = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    return mods.contains(.control) && mods.contains(.option)
}
```

Change `keyCode` to the desired key (e.g. `0` = A, `1` = S, `2` = D) and adjust the modifier flags (`.command`, `.control`, `.option`, `.shift`). Then rebuild with `./install.sh`.

## License

[MIT](LICENSE)
