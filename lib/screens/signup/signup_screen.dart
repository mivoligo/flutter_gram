import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.failure.message!),
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Fluttergram',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Username'),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .usernameChanged(value),
                            validator: (value) =>
                                value != null && value.trim().isEmpty
                                    ? 'Provide username'
                                    : null,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) =>
                                context.read<SignupCubit>().emailChanged(value),
                            validator: (value) =>
                                value != null && !value.contains('@')
                                    ? 'Please provide valid email'
                                    : null,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .passwordChanged(value),
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Please provide longer password'
                                    : null,
                          ),
                          ElevatedButton(
                            onPressed: () => _submitForm(
                              context,
                              state.status == SignupStatus.submitting,
                            ),
                            child: Text('Sign up'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Back to Log in'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[200],
                              onPrimary: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
