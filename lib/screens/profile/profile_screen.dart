import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/error_dialog.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message!),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Text('profile'),
          ),
        );
      },
    );
  }
}
