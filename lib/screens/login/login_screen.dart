import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (_, __, ___) => LoginScreen(),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                        onChanged: print,
                        validator: (value) {
                          if (value != null) {
                            !value.contains('@')
                                ? 'Please provide valid email'
                                : null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Password'),
                        onChanged: print,
                        validator: (value) {
                          if (value != null) {
                            value.length < 6
                                ? 'Please provide longer password'
                                : null;
                          }
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print('log in');
                        },
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
      ),
    );
  }
}
