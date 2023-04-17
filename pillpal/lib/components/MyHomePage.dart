import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'user_info_page.dart';
import 'about_med_page.dart';
import 'calendar_page.dart';

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
        String? test_id = "0dV968LPUR";
        NotificationController.scheduleNewNotification(test_id, "Notre Dame", "Time to take your 2 doses of Notre Dame!", "Go Irish!", DateTime.now().add(const Duration(seconds: 10)));
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