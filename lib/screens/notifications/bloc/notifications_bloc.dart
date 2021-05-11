import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(
      {required NotificationRepository notificationRepository,
      required AuthBloc authBloc})
      : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial()) {
    _notificationSubscription?.cancel();
    _notificationSubscription = _notificationRepository
        .getUserNotifications(userId: _authBloc.state.user!.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });
  }

  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Notif?>>>? _notificationSubscription;

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is NotificationsUpdateNotifications) {
      yield* _mapNotificationsUpdateNotificationsToState(event);
    }
  }

  Stream<NotificationsState> _mapNotificationsUpdateNotificationsToState(
      NotificationsUpdateNotifications event) async* {
    yield state.copyWith(
      notifications: event.notifications,
      status: NotificationStatus.loaded,
    );
  }
}
