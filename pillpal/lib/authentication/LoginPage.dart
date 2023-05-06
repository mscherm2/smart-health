import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../main.dart';
import '../services/about_med_service.dart';
import '../utils/message.dart';
import 'ResetPasswordPage.dart';
import 'SignUpPage.dart';
import 'UserPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                      'assets/images/large_logo.png'),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerUsername,
                  enabled: !isLoggedIn,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'username'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  enabled: !isLoggedIn,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'password'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoggedIn ? null : () => doUserLogin(),
                    child: const Text('login', style: TextStyle(fontSize: 20)).tr(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('signup', style: TextStyle(fontSize: 20)).tr(),
                    onPressed: () => navigateToSignUp(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('resetpassword', style: TextStyle(fontSize: 20)).tr(),
                    onPressed: () => navigateToResetPassword(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: const Text('changelanguage', style: TextStyle(fontSize: 20)).tr(),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    height: 50,
                    child: DropdownButton<Locale>(
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (Locale? value) {
                        context.setLocale(value!);
                      },
                      items: [
                        DropdownMenuItem<Locale>(
                          value: Locale('en', 'US'),
                          child: Text('english', style: TextStyle(fontSize: 20)).tr(),
                        ),
                        DropdownMenuItem<Locale>(
                          value: Locale('es', 'US'),
                          child: Text('spanish', style: TextStyle(fontSize: 20)).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser != null) {
        //Checks whether the user's session token is valid
        final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

        if (parseResponse?.success == null || !parseResponse!.success) {
          //Invalid session. Logout
          await currentUser.logout();
        } else {
          var userNotifications =
          await AwesomeNotifications().listScheduledNotifications();

          if (userNotifications.isEmpty) {

            var userMeds = await getMedByUserID(currentUser.objectId);

            for (ParseObject userMed in userMeds) {
              var doseCount = userMed.get("doseCount");
              var amt = userMed.get("amt");
              List<DateTime> notificationTimes = userMed.get("Time").cast<
                  DateTime>();
              List<dynamic> controllerDays = userMed.get("days");

              var weekdayInts = [];
              for (var day in controllerDays) {
                switch (day.toString()) {
                  case "Mon":
                    {
                      weekdayInts.add(1);
                    }
                    break;
                  case "Tue":
                    {
                      weekdayInts.add(2);
                    }
                    break;
                  case "Wed":
                    {
                      weekdayInts.add(3);
                    }
                    break;
                  case "Thu":
                    {
                      weekdayInts.add(4);
                    }
                    break;
                  case "Fri":
                    {
                      weekdayInts.add(5);
                    }
                    break;
                  case "Sat":
                    {
                      weekdayInts.add(6);
                    }
                    break;
                  case "Sun":
                    {
                      weekdayInts.add(7);
                    }
                    break;
                }
              }

              while (!weekdayInts.contains(notificationTimes[0].weekday)) {
                notificationTimes.add(notificationTimes[0].add(Duration(days: 1)));
                notificationTimes.removeAt(0);
              }

              while (notificationTimes.isNotEmpty) {
                if (DateTime.now().compareTo(notificationTimes[0]) < 0) {
                  NotificationController.scheduleNewNotification(
                      userMed.get("objectId"),
                      userMed.get("Name"),
                      'notificationprompt'.tr(args: [userMed.get("Name")]),
                      userMed.get("Desc"),
                      notificationTimes[0]);

                  doseCount -= amt;

                  if (doseCount <= 0) {
                    break;
                  }
                }

                notificationTimes.add(notificationTimes[0].add(Duration(days: 1)));
                notificationTimes.removeAt(0);

                while (!weekdayInts.contains(notificationTimes[0].weekday)) {
                  notificationTimes.add(
                      notificationTimes[0].add(Duration(days: 1)));
                  notificationTimes.removeAt(0);
                }
              }
            }
          }
        }
      }

      navigateToUser();
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }

  void navigateToUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
          (Route<dynamic> route) => false,
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }
}