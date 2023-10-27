import 'package:flutter/material.dart';
import 'package:medibuddy/main.dart';
import 'package:medibuddy/models/database_handler.dart';
import 'package:medibuddy/models/medication_notification.dart';

final handler = DatabaseHandler();

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _newReminderPressed() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final tempIdString = DateTime.now().millisecondsSinceEpoch.toString();
      final newId = int.parse(tempIdString.substring(tempIdString.length - 5));
      handler.insertMedicationNotification(
        MedicationNotification(
          id: newId,
          time: selectedTime,
        ),
      );
      notificationManager.scheduleDailyNotification(selectedTime, newId);
      setState(() {});
    }
  }

  void _deleteReminderPressed(int id) async {
    notificationManager.cancelNotification(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Scheduled reminders",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: handler.fetchMedicationNotifications(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<MedicationNotification>> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.isEmpty
                            ? const Center(
                                child: Text('No medication reminders.'))
                            : ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(snapshot.data![index].time
                                      .format(context)),
                                  trailing: IconButton(
                                    onPressed: () => _deleteReminderPressed(
                                        snapshot.data![index].id),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: snapshot.data!.length,
                              );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: _newReminderPressed,
                        icon: const Icon(Icons.add)),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 24),
            // OutlinedButton(
            //   child: const Text('Show Notification'),
            //   onPressed: () async {
            //     await notificationManager.showNotification();
            //   },
            // ),
            // const SizedBox(height: 3),
            // OutlinedButton(
            //   child: const Text('Schedule Notification for Every Minuet'),
            //   onPressed: () async {
            //     await notificationManager.repeatNotification();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
