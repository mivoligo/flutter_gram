import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/widgets.dart';
import '../screens.dart';
import 'cubit/search_users_cubit.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: true,
              border: InputBorder.none,
              hintText: 'Search Users',
              suffix: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchUsersCubit>().clearSearch();
                  _textController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchUsersCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchUsersCubit, SearchUsersState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(text: state.failure.message!);
              case SearchStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              radius: 20.0,
                              profileImageUrl: user.profileImageUrl,
                            ),
                            title: Text(
                              user.username,
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: ProfileScreenArgs(userId: user.id),
                            ),
                          );
                        },
                      )
                    : const CenteredText(text: 'No users found');
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
