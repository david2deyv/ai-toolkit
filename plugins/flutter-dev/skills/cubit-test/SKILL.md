---
name: cubit-test
description: Use when a Cubit in a Flutter project was created or changed, or the user asks «напиши тест на cubit», «покрий cubit тестом». Writes flutter_test tests for the invariants the cubit promises (double tap, stale responses, emit after close, error clearing, rollback). If the project has its own cubit-test skill, use that one instead.
---

# Тест на інваріанти Cubit

## Спочатку подивись проєкт

- Чи є вже тест на якийсь cubit у `test/`? Якщо є, бери його за зразок: стиль фейків, імпорти, назви.
- Чи є `bloc_test` / `mocktail` у `pubspec.yaml`? Нових залежностей не додавай.
- Чи є правила проєкту (CLAUDE.md, AGENTS.md, `.claude/rules/`)? Вони важливіші за цей файл.

## Де і чим

- Файл дзеркалить шлях у `test/`: `lib/<...>/<x>_cubit.dart` → `test/<...>/<x>_cubit_test.dart`.
- За замовчуванням тільки `flutter_test` і **ручні фейки** (`class _Repo implements XRepository`) з лічильниками викликів і керованими результатами. Їх легше читати, ніж `when(...)`.
- Залежності (репозиторій, роутер, аналітика, `DateTime Function() now`) передаються фейками через конструктор cubit. Сервіс-локатор (`getIt`) у тесті не реєструвати.
- Щоб притримати асинхронну відповідь фейка, використовуй `Completer`, а не `Future.delayed`.
- Кожен тест закінчується `await cubit.close()`.

## Що перевіряти (усе, що стосується цього cubit)

1. **Подвійний тап**: два виклики `submit()` підряд, поки перший висить на `Completer` → репозиторій викликано 1 раз.
2. **Застаріла відповідь**: запит A висить, запит B завершився, потім завершується A → стейт від B, не від A.
3. **Закритий cubit**: `close()`, поки запит висить, потім завершити `Completer` → без `StateError` (emit після close).
4. **Помилка**: репозиторій кидає або повертає помилку → помилка в стейті, прапорець завантаження = false; наступна успішна дія прибирає помилку.
5. **Відкат**: оптимістичне оновлення + збій → стейт повернувся до попереднього.
6. **Replace vs merge**: повна відповідь з сервера заміняє стейт і не лишає фантомних полів зі старого.
7. **Час**: межі кешу й дедлайнів перевіряй через фейковий `now`, а не реальний годинник.

Назва тесту описує інваріант словами (`'second tap while submitting does not call repository again'`), а не назву методу.

## Перевірка

```bash
dart format test/<шлях>/        # або fvm dart format, якщо в проєкті є .fvmrc
flutter test test/<шлях>/       # або fvm flutter test
```

Тест, який проходить, треба хоча б раз побачити червоним: тимчасово прибери guard у cubit (наприклад `if (state.isSubmitting) return`), тест має впасти; потім поверни guard. У відповіді напиши, що запускав і який результат.
