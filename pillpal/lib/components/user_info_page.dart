import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../main.dart';
import '../services/user_service.dart';

class UserInfoPage extends StatelessWidget {
  ParseUser? currentUser;

  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    void doUserLogout() async {
      var response = await currentUser!.logout();
      if (response.success) {
        Message.showSuccess(
            context: context,
            message: 'User was successfully logout!',
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
    }

    //String? doctor = await getDoctor();
    //print(doctor);

    return Scaffold(
        body: FutureBuilder<ParseUser?>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.data?.username != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(
                      height: 75,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.lightGreenAccent,
                          border: Border.all(
                            color: Colors.lightGreenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Username: ${snapshot.data?.get('username')}\nEmail: ${snapshot.data?.get('email')}", textAlign: TextAlign.center,)]
                      )
                    ),
                      SizedBox(
                          height: 25
                      ),
                      Container(
                          height: 75,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              border: Border.all(
                                color: Colors.lightGreenAccent,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Doctor Information:", textAlign: TextAlign.center,)]
                          )
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Container(
                          height: 75,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              border: Border.all(
                                color: Colors.lightGreenAccent,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Pharmacy Information:", textAlign: TextAlign.center,)]
                          )
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Change Language'),
                          onPressed: () => doUserLogout(),
                        ),
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Logout'),
                          onPressed: () => doUserLogout(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text("Hello");
              }
            }
        )
    );
  }
}