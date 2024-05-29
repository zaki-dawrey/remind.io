import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/providers/reminder_provider.dart';
import 'package:reminder/screens/reminder_form.dart';
import 'package:reminder/state/auth/providers/auth_state_provider.dart';
import 'package:reminder/state/dialogs/logout_dialog.dart';
import 'package:reminder/screens/login_screen.dart';

class ReminderList extends ConsumerStatefulWidget {
  const ReminderList({super.key});

  @override
  _ReminderListState createState() => _ReminderListState();
}

class _ReminderListState extends ConsumerState<ReminderList> {
  String? _selectedPriority;

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(reminderProvider).where((reminder) {
      if (_selectedPriority == null) {
        return true;
      } else {
        return reminder.priority == _selectedPriority;
      }
    }).toList();

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
          DropdownButton<String>(
            value: _selectedPriority,
            hint: const Text("Filter by priority"),
            onChanged: (String? newValue) {
              setState(() {
                _selectedPriority = newValue;
              });
            },
            items: <String>['All', 'High', 'Medium', 'Low']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value == 'All' ? null : value,
                child: Text(value),
              );
            }).toList(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReminderForm()),
          );
        },
        child: const Icon(Icons.add),
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
