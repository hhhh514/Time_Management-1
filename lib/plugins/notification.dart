import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationPlugin {
  final FlutterLocalNotificationsPlugin np = FlutterLocalNotificationsPlugin();

  init() async {
    tz.initializeTimeZones(); // 初始化時區資料庫
    tz.setLocalLocation(tz.getLocation('Asia/Taipei'));
    // 在 Android 平台上的設置，並使用 flutter logo 作為通知顯示的圖標
    var android = const AndroidInitializationSettings('flutter_logo');

    // 在 iOS 平台上的設置，並設置了 iOS 通知的權限
    var ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    // 註冊不同平台初始化設置的 InitializationSetting 對象
    var initSettings = InitializationSettings(android: android);

    // 使用 np 實例的 initialize 方法初始化本地通知插件
    await np.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {}
    );
  }
  // 觸發通知時，透過呼叫此函式來顯示通知
  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return np.show(id, title, body, await notificationDetails());
  }

  notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
      //iOS: DarwinNotificationDetails(),
    );
  }

  Future showScheduledNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payload,
        required DateTime scheduledDate}) async {
    return np.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  removeScheduledNotification(int id) async{
    await np.cancel(id);
  }
}