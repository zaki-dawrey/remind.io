import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:reminder/state/auth/providers/auth_state_provider.dart';

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  return ReminderNotifier(ref);
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  final StateNotifierProviderRef<ReminderNotifier, List<Reminder>> ref;

  ReminderNotifier(this.ref) : super([]) {
    loadReminders();
  }

  Future<void> loadReminders() async {
    final userId = ref.read(authStateProvider).userId;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('reminders')
          .where('userId', isEqualTo: userId)
          .get();
      state =
          snapshot.docs.map((doc) => Reminder.fromJson(doc.data())).toList();
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminder.id)
        .set(reminder.toJson());
    state = [...state, reminder];

    NotificationService.showNotification(
      id: reminder.id.hashCode,
      title: reminder.title,
      body: reminder.description,
      scheduledDate: reminder.time,
    );
  }

  Future<void> editReminder(Reminder reminder) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminder.id)
        .update(reminder.toJson());
    state = [
      for (final r in state)
        if (r.id == reminder.id) reminder else r,
    ];

    NotificationService.showNotification(
      id: reminder.id.hashCode,
      title: reminder.title,
      body: reminder.description,
      scheduledDate: reminder.time,
    );
  }

  Future<void> deleteReminder(String id) async {
    await FirebaseFirestore.instance.collection('reminders').doc(id).delete();
    state = state.where((r) => r.id != id).toList();

    NotificationService.cancelNotification(id.hashCode);
  }
}
