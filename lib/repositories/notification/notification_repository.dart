import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/paths.dart';
import '../../models/notif_model.dart';
import '../repositories.dart';

class NotificationRepository extends BaseNotificationRepository {
  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Stream<List<Future<Notif?>>> getUserNotifications({required String userId}) {
    return _firebaseFirestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map(Notif.fromDocument).toList(),
        );
  }
}
