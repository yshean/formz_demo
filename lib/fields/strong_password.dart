import 'package:formz/formz.dart';

/// Strong Password Form Input Validation Error
enum StrongPasswordValidationError {
  /// Password is empty
  empty,

  /// Password is not strong enough
  passwordNotStrongEnough,
}

/// {@template strong_password}
/// Reusable strong password form input.
/// {@endtemplate}
class StrongPassword extends FormzInput<String, StrongPasswordValidationError> {
  /// {@macro strong_password}
  const StrongPassword.pure() : super.pure('');

  /// {@macro strong_password}
  const StrongPassword.dirty([super.value = '']) : super.dirty();

  static final _containsNumberRegex = RegExp('[0-9]');

  static final _containsLowerUppercaseRegex =
      RegExp(r'(?=.*[a-z])(?=.*[A-Z])\w+');

  @override
  StrongPasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return StrongPasswordValidationError.empty;
    }
    if (value.length < 9 ||
        !_containsNumberRegex.hasMatch(value) ||
        !_containsLowerUppercaseRegex.hasMatch(value)) {
      return StrongPasswordValidationError.passwordNotStrongEnough;
    }
    return null;
  }
}

extension StrongPasswordValidationErrorX on StrongPasswordValidationError {
  String message() {
    switch (this) {
      case StrongPasswordValidationError.passwordNotStrongEnough:
        return 'Please choose a stronger password';
      case StrongPasswordValidationError.empty:
        return 'Please enter a password';
    }
  }
}
