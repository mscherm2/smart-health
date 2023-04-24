import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    label: 'navbarmeds'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined),
                    label: 'navbarcal'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'navbarprofile'.tr(),
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