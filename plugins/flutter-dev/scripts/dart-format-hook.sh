#!/usr/bin/env bash
# PostToolUse-хук: форматує .dart-файл після Write/Edit/MultiEdit.
# Згенеровані файли (*.g.dart, *.freezed.dart, *.config.dart, lib/flavors.dart) не чіпає.
# Ніколи не блокує агента: будь-яка помилка → exit 0.
f=$(jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0
case "$f" in
  *.g.dart|*.freezed.dart|*.config.dart|*/lib/flavors.dart) exit 0 ;;
  *.dart) ;;
  *) exit 0 ;;
esac
[ -f "$f" ] || exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
fvm dart format "$f" >/dev/null 2>&1 || dart format "$f" >/dev/null 2>&1 || true
exit 0
