import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:medibuddy/navigation.dart';
import 'package:medibuddy/notification_manager.dart';

final notificationManager = NotificationManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notificationManager.initializeNotifications();
  print(await notificationManager.checkPermissions());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
              circularTrackColor: lightColorScheme?.surface,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
              circularTrackColor: darkColorScheme?.surface,
            ),
          ),
          home: const Navigation(),
        );
      },
    );
  }
}
