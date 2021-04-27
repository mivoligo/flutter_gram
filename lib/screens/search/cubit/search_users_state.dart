part of 'search_users_cubit.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchUsersState extends Equatable {
  const SearchUsersState({
    required this.users,
    required this.status,
    required this.failure,
  });

  factory SearchUsersState.initial() {
    return SearchUsersState(
      users: [],
      status: SearchStatus.initial,
      failure: Failure(),
    );
  }

  final List<User> users;
  final SearchStatus status;
  final Failure failure;

  @override
  List<Object> get props => [users, status, failure];

  SearchUsersState copyWith({
    List<User>? users,
    SearchStatus? status,
    Failure? failure,
  }) {
    return SearchUsersState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
