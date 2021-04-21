import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/user_profile_image.dart';
import '../profile/bloc/profile_bloc.dart';
import 'cubit/edit_profile_cubit.dart';

class EditProfileScreenArgs {
  const EditProfileScreenArgs({required this.context});

  final BuildContext context;
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  EditProfileScreen({Key? key, required this.user}) : super(key: key);

  static Route route({required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (_) => EditProfileCubit(
            userRepository: context.read<UserRepository>(),
            storageRepository: context.read<StorageRepository>(),
            profileBloc: args.context.read<ProfileBloc>()),
        child: EditProfileScreen(
            user: args.context.read<ProfileBloc>().state.user),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) {
                  return ErrorDialog(
                    content: state.failure.message ?? 'Something went wrong',
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting)
                    const LinearProgressIndicator(),
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserProfileImage(
                        radius: 80.0,
                        profileImageUrl: user.profileImageUrl,
                        profileImage: state.profileImage,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(
                              hintText: 'Username',
                            ),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .usernameChanged(value),
                            validator: (value) =>
                                value != null && value.trim().isEmpty
                                    ? 'Username cannot be empty'
                                    : null,
                          ),
                          TextFormField(
                            initialValue: user.bio,
                            decoration: InputDecoration(
                              hintText: 'Bio',
                            ),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .bioChanged(value),
                            validator: (value) =>
                                value != null && value.trim().isEmpty
                                    ? 'Bio cannot be empty'
                                    : null,
                          ),
                          ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == EditProfileStatus.submitting),
                              child: Text('Update'))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Profile image',
    );
    if (pickedFile != null) {
      context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }
}
