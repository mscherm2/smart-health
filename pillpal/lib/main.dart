import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:pillpal/services/about_med_service.dart';

import 'authentication/LoginPage.dart';
import 'authentication/UserPage.dart';
import 'package:camera/camera.dart';

var cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // get list of the available cameras
  cameras = await availableCameras();

  final keyApplicationId = 'LpMPZJZ7AXwu5KvzLgMIdZH1C0v5UcUgxuDZfiob';
  final keyClientKey = 'lO4WnUFbxnbwVdC4rCY9m8dKF01uax8rirzQUZh1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      debug: true);

  // Always initialize Awesome Notifications
  await NotificationController.initializeLocalNotifications();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('es', 'US')],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()
    ),
  );
}

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {

    print('BUTTON KEY INPUT IS "${receivedAction.buttonKeyInput}"');
    print('BUTTON KEY PRESSED IS "${receivedAction.buttonKeyPressed}"');
    if(
      receivedAction.actionType == ActionType.SilentAction ||
      receivedAction.actionType == ActionType.SilentBackgroundAction
    ){
      // For background actions, you must hold the execution until the end
      print('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      if (receivedAction.buttonKeyPressed == 'YES') {
        await successfulDoseAdministration(receivedAction.payload!["id"]);
      } else if (receivedAction.buttonKeyPressed == 'REMINDHOUR') {
        await scheduleNewNotification(
            receivedAction.payload!["id"],
            receivedAction.payload!["name"],
            receivedAction.title,
            receivedAction.body,
            DateTime.now().add(const Duration(hours: 1))
        );
      }
    }
    else {
      MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notification-page',
              (route) =>
          (route.settings.name != '/notification-page') || route.isFirst,
          arguments: receivedAction);
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> successfulDoseAdministration(id) async {
    print("DECREMENTING DOSECOUNT!");
    var med_response = await getMedById(id);

    print(med_response);

    var update_med = ParseObject('Medication')
      ..objectId = med_response[0]["objectId"]
      ..set('doseCount', med_response[0]["doseCount"] - med_response[0]["amt"]);
    await update_med.save();
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction
          ),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification(id, name, title, body, notificationDateTime) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: title,
            body: body,
            bigPicture: 'asset://assets/images/large_logo.png',
            largeIcon: 'asset://assets/images/small_logo.png',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {
              'id': id,
              'name': name
            }),
        actionButtons: [
          NotificationActionButton(
              key: 'YES',
              label: 'Yes, I took my meds!',
              actionType: ActionType.SilentAction
          ),
          NotificationActionButton(
              key: 'REMINDHOUR',
              label: 'Remind me in 1 hour!',
              actionType: ActionType.SilentAction,
              isDangerousOption: true
          ),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss!',
              actionType: ActionType.DismissAction,
              isDangerousOption: true
          )
        ],
        schedule: NotificationCalendar.fromDate(date: notificationDateTime));
  }
}

///  *********************************************
///     MAIN WIDGET
///  *********************************************
///
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Color mainColor = const Color(0xFF9D50DD);

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  // This widget is the root of your application.

  static const String routeHome = '/', routeNotification = '/notification-page';

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];
    pageStack.add(MaterialPageRoute(
        builder: (context) => FutureBuilder<bool>(
            future: hasUserLogged(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Scaffold(
                    body: Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()),
                    ),
                  );
                default:
                  if (snapshot.hasData && snapshot.data!) {
                    print('LOADING USER PAGE');
                    return UserPage();
                  } else {
                    print('LOADING LOGIN PAGE');
                    return LoginPage();
                  }
              }
            })));
    if (initialRouteName == routeNotification &&
        NotificationController.initialAction != null) {
      pageStack.add(MaterialPageRoute(
          builder: (_) => NotificationPage(
              receivedAction: NotificationController.initialAction!)));
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<bool>(
              future: hasUserLogged(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Scaffold(
                      body: Center(
                        child: Container(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  default:
                    if (snapshot.hasData && snapshot.data!) {
                      print('LOADING USER PAGE');
                      return UserPage();
                    } else {
                      print('LOADING LOGIN PAGE');
                      return LoginPage();
                    }
                }
              }));

      case routeNotification:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
            builder: (_) => NotificationPage(receivedAction: receivedAction));
    }
    return null;
  }

  Future<bool> hasUserLogged() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
    await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'title'.tr(),
      navigatorKey: MyApp.navigatorKey,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // TODO: font not working
        fontFamily: 'Poppins',
      ),
    );
  }
}

///  *********************************************
///     NOTIFICATION PAGE
///  *********************************************
///
class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key, required this.receivedAction})
      : super(key: key);

  final ReceivedAction receivedAction;

  void successNotificationHandler(context) async {
    await NotificationController.successfulDoseAdministration(receivedAction.payload!["id"]);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
          (Route<dynamic> route) => false,
    );
  }

  void remindInHourHandler(context) async {
    await NotificationController.scheduleNewNotification(
        receivedAction.payload!["id"],
        receivedAction.payload!["name"],
        receivedAction.title,
        receivedAction.body,
        DateTime.now().add(const Duration(hours: 1))
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasLargeIcon = receivedAction.largeIconImage != null;
    bool hasBigPicture = receivedAction.bigPictureImage != null;
    double bigPictureSize = MediaQuery.of(context).size.height * .4;
    double largeIconSize =
        MediaQuery.of(context).size.height * (hasBigPicture ? .12 : .2);

    return Scaffold(
      appBar: AppBar(
        title: Text(receivedAction.title ?? receivedAction.body ?? ''),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height:
                    hasBigPicture ? bigPictureSize + 40 : largeIconSize + 60,
                child: hasBigPicture
                    ? Stack(
                        children: [
                          if (hasBigPicture)
                            FadeInImage(
                              placeholder: const NetworkImage(
                                  'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                              //AssetImage('assets/images/placeholder.gif'),
                              height: bigPictureSize,
                              width: MediaQuery.of(context).size.width,
                              image: receivedAction.bigPictureImage!,
                              fit: BoxFit.cover,
                            ),
                          if (hasLargeIcon)
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(largeIconSize)),
                                child: FadeInImage(
                                  placeholder: const NetworkImage(
                                      'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                                  //AssetImage('assets/images/placeholder.gif'),
                                  height: largeIconSize,
                                  width: largeIconSize,
                                  image: receivedAction.largeIconImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        ],
                      )
                    : Center(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(largeIconSize)),
                          child: FadeInImage(
                            placeholder: const NetworkImage(
                                'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
                            //AssetImage('assets/images/placeholder.gif'),
                            height: largeIconSize,
                            width: largeIconSize,
                            image: receivedAction.largeIconImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    if (receivedAction.title?.isNotEmpty ?? false)
                      TextSpan(
                        text: receivedAction.title!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    if ((receivedAction.title?.isNotEmpty ?? false) &&
                        (receivedAction.body?.isNotEmpty ?? false))
                      TextSpan(
                        text: '\n\n',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (receivedAction.body?.isNotEmpty ?? false)
                      TextSpan(
                        text: receivedAction.body!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ]))
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text('med_success', style: TextStyle(fontSize: 16)).tr(),
                    onPressed: () => successNotificationHandler(context)
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    child: Text('remindhour', style: TextStyle(fontSize: 16)).tr(),
                    onPressed: () => remindInHourHandler(context)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
