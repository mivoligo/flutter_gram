import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/widgets.dart';

import 'bloc/notifications_bloc.dart';
import 'widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationStatus.loaded:
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return NotificationTile(notification: notification!);
                },
              );
            case NotificationStatus.error:
              return CenteredText(text: state.failure.message ?? 'Error');
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
