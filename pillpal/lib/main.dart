import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

import 'components/about_med_page.dart';
import 'components/calendar_page.dart';
import 'components/user_info_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  const keyApplicationId = 'LpMPZJZ7AXwu5KvzLgMIdZH1C0v5UcUgxuDZfiob';
  const keyClientKey = 'lO4WnUFbxnbwVdC4rCY9m8dKF01uax8rirzQUZh1';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      debug: true);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('es', 'US')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
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
                  return UserPage();
                } else {
                  return LoginPage();
                }
            }
          }),
    );
  }
}

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
        appBar: AppBar(
          title: const Text('title').tr(),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                      'assets/images/curr_logo.png'),
                ),
                Center(
                  child: const Text('title',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(),
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
                      labelText: 'username'.tr()),
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
                      labelText: 'password'.tr()),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('login').tr(),
                    onPressed: isLoggedIn ? null : () => doUserLogin(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('signup').tr(),
                    onPressed: () => navigateToSignUp(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('resetpassword').tr(),
                    onPressed: () => navigateToResetPassword(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: const Text('changelanguage').tr(),
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
                          child: Text('english').tr(),
                        ),
                        DropdownMenuItem<Locale>(
                          value: Locale('es', 'US'),
                          child: Text('spanish').tr(),
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

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('title').tr(),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                      'assets/images/curr_logo.png'),
                ),
                Center(
                  child: const Text('title',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: const Text('userregistration',
                      style: TextStyle(fontSize: 16)).tr(),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerUsername,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'username'.tr()),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'email'.tr()),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'password'.tr()),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('signup').tr(),
                    onPressed: () => doUserRegistration(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: const Text('changelanguage').tr(),
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
                          child: Text('english').tr(),
                        ),
                        DropdownMenuItem<Locale>(
                          value: Locale('es', 'US'),
                          child: Text('spanish').tr(),
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

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser.createUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      Message.showSuccess(
          context: context,
          message: 'successful'.tr(),
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
                  (Route<dynamic> route) => false,
            );
          });
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }
}

class UserPage extends StatelessWidget {
  ParseUser? currentUser;

  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<ParseUser?>(
            future: getUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
                default:
                  return ChangeNotifierProvider(
                    create: (context) => MyAppState(),
                    child: MaterialApp(
                      title: 'title'.tr(),
                      theme: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
                      ),
                      home: MyHomePage(),
                    ),
                  );
              }
            }));
  }
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('resetpassword').tr(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'email'.tr()),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: const Text('resetpassword').tr(),
                  onPressed: () => doUserResetPassword(),
                ),
              )
            ],
          ),
        ));
  }

  void doUserResetPassword() async {}
}

class Message {
  static void showSuccess(
      {required BuildContext context,
        required String message,
        VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('success').tr(),
          content: Text(message),
          actions: <Widget>[
            new ElevatedButton(
              child: const Text('ok').tr(),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showError(
      {required BuildContext context,
        required String message,
        VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('error').tr(),
          content: Text(message),
          actions: <Widget>[
            new ElevatedButton(
              child: const Text('ok').tr(),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = 'pillpal here';


  var favorites = [];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = AboutMedPage();
        break;
      case 1:
        page = CalendarPage();
        break;
      case 2:
        page = UserInfoPage();
        break;
      default:
        throw UnimplementedError('nowidget'.tr(args: [selectedIndex.toString()]));
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            appBar: AppBar(
              title: Text('title', style: TextStyle(color: Colors.white),).tr(),
              centerTitle: true,
              backgroundColor: Color(0xff020887),
            ),
            body: Center(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
              bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.medication),
                    label: 'Meds',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined),
                    label: 'Calendar',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              )
          );
        }
    );
  }
}