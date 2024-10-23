import 'package:formz/formz.dart';
import 'package:formz_demo/fields/strong_password.dart';

/// Confirm Password Form Input Validation Error
enum ConfirmPasswordValidationError {
  /// password does not match
  passwordsDoNotMatch,

  /// password is empty
  empty,
}

/// {@template password}
/// Reusable confirm password form input.
/// {@endtemplate}
class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure()
      : original = const StrongPassword.pure(),
        super.pure('');
  const ConfirmPassword.dirty({required this.original, String value = ''})
      : super.dirty(value);

  /// The password to compare against
  final StrongPassword original;

  @override
  ConfirmPasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    }
    if (value != original.value) {
      return ConfirmPasswordValidationError.passwordsDoNotMatch;
    }
    return null;
  }
}

extension ConfirmPasswordValidationErrorX on ConfirmPasswordValidationError {
  String message() {
    switch (this) {
      case ConfirmPasswordValidationError.passwordsDoNotMatch:
        return 'The passwords do not match';
      case ConfirmPasswordValidationError.empty:
        return 'Please enter a confirm password';
    }
  }
}
