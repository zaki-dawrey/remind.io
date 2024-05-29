import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/providers/reminder_provider.dart';
import 'package:reminder/screens/reminder_form.dart';
import 'package:reminder/state/auth/providers/auth_state_provider.dart';
import 'package:reminder/state/dialogs/logout_dialog.dart';
import 'package:reminder/screens/login_screen.dart';

class ReminderList extends ConsumerWidget {
  const ReminderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.userId == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReminderForm()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                bool logoutConfirmed = await showLogOutDialog(context);

                if (logoutConfirmed) {
                  ref.read(authStateProvider.notifier).logOut();
                }
              },
              child: const Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text('${reminder.description}\n${reminder.time}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReminderForm(reminder: reminder),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref
                        .read(reminderProvider.notifier)
                        .deleteReminder(reminder.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
