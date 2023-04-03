import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:easy_localization/easy_localization.dart';

import '../main.dart';
import '../services/user_service.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void doUserLogout() async {
      try {
        ParseUser? currentUser = await getUser();
        var response = await currentUser!.logout();
        if (response.success) {
          Message.showSuccess(
              context: context,
              message: 'logoutmsg'.tr(),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              });
        } else {
          Message.showError(context: context, message: response.error!.message);
        }
      } catch(e) {
        Message.showError(
            context: context,
            message: 'logouterror'.tr(),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            });
      }
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(207, 229, 252, 1),
        body: FutureBuilder(
            future: Future.wait([getUser(), getDoctor(), getPharmacy()]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.data?[0].username != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SizedBox(
                        height: 75
                    ),
                      Container(
                          height: 75,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('userinfo', textAlign: TextAlign.center,).tr(args: [snapshot.data?[0].get('username'), snapshot.data?[0].get('email')])]
                          )
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Expanded(
                        child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('userinfodoctor', textAlign: TextAlign.center,).tr(args: [snapshot.data?[1].get('name'), snapshot.data?[1].get('email'), snapshot.data?[1].get('phone'), snapshot.data?[1].get('other_info')])]
                            )
                        ),
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Expanded(
                        child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('userinfopharmacy', textAlign: TextAlign.center,).tr(args: [snapshot.data?[2].get('name'), snapshot.data?[2].get('addr'), snapshot.data?[2].get('city'), snapshot.data?[2].get('state'), snapshot.data?[2].get('zip'), snapshot.data?[2].get('phone')])]
                            )
                        ),
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Text('changelanguage').tr(),
                      Container(
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
                      SizedBox(
                          height: 25
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('logout').tr(),
                          onPressed: () => doUserLogout(),
                        ),
                      ),
                      SizedBox(
                          height: 25
                      ),
                    ],
                  ),
                );
              } else {
                return Text('hello').tr();
              }
            }
        )
    );
  }
}