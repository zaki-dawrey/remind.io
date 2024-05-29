import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/providers/reminder_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:reminder/state/auth/providers/auth_state_provider.dart';

class ReminderForm extends ConsumerStatefulWidget {
  final Reminder? reminder;

  const ReminderForm({super.key, this.reminder});

  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends ConsumerState<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _time;
  late String _priority;

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _title = widget.reminder!.title;
      _description = widget.reminder!.description;
      _time = widget.reminder!.time;
      _priority = widget.reminder!.priority;
    } else {
      _title = '';
      _description = '';
      _time = DateTime.now();
      _priority = 'Medium';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _time,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _time) {
      setState(() {
        _time = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _time.hour,
          _time.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );
    if (pickedTime != null) {
      setState(() {
        _time = DateTime(
          _time.year,
          _time.month,
          _time.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: DateFormat.yMMMd().format(_time),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText: TimeOfDay.fromDateTime(_time).format(context),
                      ),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                        value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                onSaved: (value) {
                  _priority = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final reminder = Reminder(
                      id: widget.reminder?.id ?? const Uuid().v4(),
                      title: _title,
                      description: _description,
                      time: _time,
                      priority: _priority,
                      userId: ref
                          .read(authStateProvider)
                          .userId!, 
                    );
                    if (widget.reminder == null) {
                      ref.read(reminderProvider.notifier).addReminder(reminder);
                    } else {
                      ref
                          .read(reminderProvider.notifier)
                          .editReminder(reminder);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.reminder == null ? 'Add' : 'Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
