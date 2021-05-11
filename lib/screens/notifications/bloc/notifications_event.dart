part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class NotificationsUpdateNotifications extends NotificationsEvent {
  NotificationsUpdateNotifications({required this.notifications});

  final List<Notif?> notifications;

  @override
  List<Object?> get props => [notifications];
}
