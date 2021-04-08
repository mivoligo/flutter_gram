import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.error) {
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
                            decoration: InputDecoration(hintText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) =>
                                context.read<LoginCubit>().emailChanged(value),
                            validator: (value) =>
                                value != null && !value.contains('@')
                                    ? 'Please provide valid email'
                                    : null,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            onChanged: (value) => context
                                .read<LoginCubit>()
                                .passwordChanged(value),
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Please provide longer password'
                                    : null,
                          ),
                          ElevatedButton(
                            onPressed: () => _submitForm(
                              context,
                              state.status == LoginStatus.submitting,
                            ),
                            child: Text('Log in'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print('sign in');
                            },
                            child: Text('No account? Sign up'),
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
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
