import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:medibuddy/navigation.dart';
import 'package:medibuddy/notification_manager.dart';

final notificationManager = NotificationManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // // NotificationService().init();
  // // await _configureLocalTimeZone();
  //
  // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //
  // // String initialRoute = MyApp.routeName;
  // // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  // //   selectedNotificationPayload =
  // //       notificationAppLaunchDetails!.notificationResponse?.payload;
  // //   initialRoute = SecondPage.routeName;
  // // }
  //
  // // const AndroidInitializationSettings initializationSettingsAndroid =
  // //     AndroidInitializationSettings('app_icon');
  // AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings("@mipmap/ic_launcher");
  //
  // final List<DarwinNotificationCategory> darwinNotificationCategories =
  //     <DarwinNotificationCategory>[
  //   DarwinNotificationCategory(
  //     darwinNotificationCategoryText,
  //     actions: <DarwinNotificationAction>[
  //       DarwinNotificationAction.text(
  //         'text_1',
  //         'Action 1',
  //         buttonTitle: 'Send',
  //         placeholder: 'Placeholder',
  //       ),
  //     ],
  //   ),
  //   DarwinNotificationCategory(
  //     darwinNotificationCategoryPlain,
  //     actions: <DarwinNotificationAction>[
  //       DarwinNotificationAction.plain('id_1', 'Action 1'),
  //       DarwinNotificationAction.plain(
  //         'id_2',
  //         'Action 2 (destructive)',
  //         options: <DarwinNotificationActionOption>{
  //           DarwinNotificationActionOption.destructive,
  //         },
  //       ),
  //       DarwinNotificationAction.plain(
  //         navigationActionId,
  //         'Action 3 (foreground)',
  //         options: <DarwinNotificationActionOption>{
  //           DarwinNotificationActionOption.foreground,
  //         },
  //       ),
  //       DarwinNotificationAction.plain(
  //         'id_4',
  //         'Action 4 (auth required)',
  //         options: <DarwinNotificationActionOption>{
  //           DarwinNotificationActionOption.authenticationRequired,
  //         },
  //       ),
  //     ],
  //     options: <DarwinNotificationCategoryOption>{
  //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
  //     },
  //   )
  // ];
  //
  // /// Note: permissions aren't requested here just to demonstrate that can be
  // /// done later
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings(
  //   requestAlertPermission: false,
  //   requestBadgePermission: false,
  //   requestSoundPermission: false,
  //   onDidReceiveLocalNotification:
  //       (int id, String? title, String? body, String? payload) async {
  //     didReceiveLocalNotificationStream.add(
  //       ReceivedNotification(
  //         id: id,
  //         title: title,
  //         body: body,
  //         payload: payload,
  //       ),
  //     );
  //   },
  //   notificationCategories: darwinNotificationCategories,
  // );
  // // final LinuxInitializationSettings initializationSettingsLinux =
  // //     LinuxInitializationSettings(
  // //   defaultActionName: 'Open notification',
  // //   defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  // // );
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsDarwin,
  //   macOS: initializationSettingsDarwin,
  //   // linux: initializationSettingsLinux,
  // );
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse:
  //       (NotificationResponse notificationResponse) {
  //     switch (notificationResponse.notificationResponseType) {
  //       case NotificationResponseType.selectedNotification:
  //         selectNotificationStream.add(notificationResponse.payload);
  //         break;
  //       case NotificationResponseType.selectedNotificationAction:
  //         if (notificationResponse.actionId == navigationActionId) {
  //           selectNotificationStream.add(notificationResponse.payload);
  //         }
  //         break;
  //     }
  //   },
  //   onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  // );
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
