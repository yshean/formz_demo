import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:formz_demo/signup_form_state.dart';

import 'fields/email.dart';
import 'fields/strong_password.dart';
import 'fields/confirm_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formz Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Formz Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class EmailAlreadyExistsException implements Exception {
  @override
  String toString() {
    return 'Email already exists';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late SignupFormState _signupFormState;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _signupFormState = const SignupFormState();
  }

  Future<void> checkEmailAvailability(String email) async {
    if (email.isEmpty) {
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'doe@john.co') {
      throw EmailAlreadyExistsException();
    }
  }

  void performEmailAvailabilityCheck() {
    checkEmailAvailability(_signupFormState.email.value).then((_) {
      setState(() {
        _signupFormState = _signupFormState.copyWith(
          asyncEmailError: () => null,
        );
      });
    }).catchError((error) {
      setState(() {
        _signupFormState = _signupFormState.copyWith(
          asyncEmailError: () => error is EmailAlreadyExistsException
              ? 'Email already exists'
              : 'Something went wrong',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          // you can use _formKey to finegrain the control the timing of validation
          key: _formKey,
          autovalidateMode: _signupFormState.isDirty
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: <Widget>[
              Focus(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (_) =>
                      _signupFormState.asyncEmailError ??
                      _signupFormState.email.error?.message(),
                  onChanged: (value) {
                    setState(() {
                      _signupFormState = _signupFormState.copyWith(
                        email: Email.dirty(value),
                      );
                    });
                  },
                ),
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    performEmailAvailabilityCheck();
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (_) => _signupFormState.password.error?.message(),
                onChanged: (value) {
                  setState(() {
                    _signupFormState = _signupFormState.copyWith(
                      password: StrongPassword.dirty(value),
                      confirmPassword: ConfirmPassword.dirty(
                        original: StrongPassword.dirty(value),
                        value: _signupFormState.confirmPassword.value,
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                autocorrect: false,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (_) =>
                    _signupFormState.confirmPassword.error?.message(),
                onChanged: (value) {
                  setState(() {
                    _signupFormState = _signupFormState.copyWith(
                      confirmPassword: ConfirmPassword.dirty(
                        original: _signupFormState.password,
                        value: value,
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _signupFormState.isValid &&
                        _signupFormState.status !=
                            FormzSubmissionStatus.inProgress
                    ? () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        setState(() {
                          _signupFormState = _signupFormState.copyWith(
                            status: FormzSubmissionStatus.inProgress,
                          );
                        });
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          _signupFormState = _signupFormState.copyWith(
                            status: FormzSubmissionStatus.success,
                          );
                        });
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Success')),
                        );
                        // TODO: Handle error state
                      }
                    : null,
                child: Text(
                    _signupFormState.status == FormzSubmissionStatus.inProgress
                        ? 'Submitting'
                        : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
