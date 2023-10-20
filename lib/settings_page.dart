import 'package:flutter/material.dart';
import 'package:medibuddy/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('Show Notification'),
              onPressed: () async {
                await notificationManager.showNotification();
              },
            ),
            const SizedBox(height: 3),
            OutlinedButton(
              child: const Text('Schedule Notification'),
              onPressed: () async {
                await notificationManager.repeatNotification();
              },
            ),
            const SizedBox(height: 3),
            OutlinedButton(
              child: const Text('Cancel Notification'),
              onPressed: () async {
                // await _notificationService.cancelNotifications(0);
              },
            ),
            const SizedBox(height: 3),
            OutlinedButton(
              child: const Text('Cancel All Notifications'),
              onPressed: () async {
                // await _notificationService.cancelAllNotifications();
              },
            ),
            const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
