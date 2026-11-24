# ai-toolkit

Мої плагіни для Claude Code: скіли, агенти, хуки — в одному місці.

## Структура

- `.claude-plugin/marketplace.json` — список плагінів
- `plugins/<назва>/` — один плагін:
  - `.claude-plugin/plugin.json` — назва, версія
  - `skills/<скіл>/SKILL.md` — скіли
  - `agents/<агент>.md` — субагенти
  - `hooks/hooks.json` — хуки (шлях до скриптів через `${CLAUDE_PLUGIN_ROOT}`)

## Плагіни

| Плагін | Що всередині |
|---|---|
| `flutter-dev` | скіл `cubit-test`, хук `dart format` після редагування |

## Як підключити

```bash
claude plugin marketplace add ~/ai-toolkit
claude plugin install flutter-dev@ai-toolkit --scope local   # у папці проєкту
```

Після змін у цьому репозиторії: `claude plugin marketplace update ai-toolkit`,
потім підняти `version` у `plugin.json`.

## Що НЕ сюди

Те, що прив'язане до коду конкретного проєкту (рев'юер Укрпошти, правила GitLab/Jira),
живе в репозиторії того проєкту.
