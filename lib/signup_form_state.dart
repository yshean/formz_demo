import 'package:formz/formz.dart';

import 'fields/confirm_password.dart';
import 'fields/email.dart';
import 'fields/strong_password.dart';

class SignupFormState with FormzMixin {
  const SignupFormState({
    this.email = const Email.pure(),
    this.password = const StrongPassword.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.asyncEmailError,
  });

  final Email email;
  final StrongPassword password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus status;
  final String? asyncEmailError;

  SignupFormState copyWith({
    Email? email,
    StrongPassword? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    String? Function()? asyncEmailError,
  }) {
    return SignupFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      asyncEmailError:
          asyncEmailError != null ? asyncEmailError() : this.asyncEmailError,
    );
  }

  @override
  bool get isValid => asyncEmailError == null && Formz.validate(inputs);

  @override
  List<FormzInput> get inputs => [email, password, confirmPassword];
}
