import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_blue_care/features/auth/application/auth_operation.dart';
import 'package:app_blue_care/features/auth/domain/auth_repository.dart';

void main() {
  test(
    'rejects overlapping operations and permits a retry after failure',
    () async {
      final operation = AuthOperation();
      addTearDown(operation.dispose);
      final pending = Completer<void>();
      var duplicateCalls = 0;
      final first = operation.run(() => pending.future);
      expect(operation.busy, isTrue);
      expect(
        await operation.run(() async {
          duplicateCalls++;
        }),
        isFalse,
      );
      expect(duplicateCalls, 0);
      pending.completeError(const AuthFailure('Sin conexión.'));
      expect(await first, isFalse);
      expect(operation.busy, isFalse);
      expect(operation.error, 'Sin conexión.');
      expect(await operation.run(() async {}), isTrue);
      expect(operation.error, isNull);
    },
  );

  test('unexpected exceptions show a generic error', () async {
    final operation = AuthOperation();
    addTearDown(operation.dispose);
    expect(
      await operation.run(() async {
        throw StateError('internal details');
      }),
      isFalse,
    );
    expect(operation.error, 'No pudimos continuar. Intenta de nuevo.');
    expect(operation.busy, isFalse);
  });

  for (final fail in [false, true]) {
    test('completion after disposal is ignored (failure: $fail)', () async {
      final operation = AuthOperation();
      final pending = Completer<void>();
      var notifications = 0;
      operation.addListener(() => notifications++);
      final result = operation.run(() => pending.future);
      expect(notifications, 1);
      operation.dispose();
      if (fail) {
        pending.completeError(const AuthFailure('Too late'));
      } else {
        pending.complete();
      }
      expect(await result, isFalse);
      expect(notifications, 1);
      expect(await operation.run(() async {}), isFalse);
    });
  }
}
