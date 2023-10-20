import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationManager {
  int id = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  static const String portName = 'notification_send_port';

  String? selectedNotificationPayload;

  /// A notification action which triggers a url launch event
  static const String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  Future<void> initializeNotifications() async {
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    //
    // String initialRoute = MyApp.routeName;
    // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    //   selectedNotificationPayload =
    //       notificationAppLaunchDetails!.notificationResponse?.payload;
    //   initialRoute = SecondPage.routeName;
    // }

    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      // linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<bool> checkPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return true;
    } else if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      if (!granted) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

        final bool? grantedNotificationPermission =
            await androidImplementation?.requestNotificationsPermission();
        return grantedNotificationPermission ?? false;
      }
      return granted;
    } else {
      return false;
    }
  }

  Future<void> repeatNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
