import '../../models/models.dart';

// ignore: one_member_abstracts
abstract class BaseNotificationRepository {
  Stream<List<Future<Notif?>>> getUserNotifications({required String userId});
}
