import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

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
      } catch(e) {
        Message.showError(
            context: context,
            message: 'Logout Error! Please try again later.',
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
                              children: [Text("Username: ${snapshot.data?[0].get('username')}\nEmail: ${snapshot.data?[0].get('email')}", textAlign: TextAlign.center,)]
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
                                children: [Text("Doctor Information:\nName: ${snapshot.data?[1].get('name')}\nEmail: ${snapshot.data?[1].get('email')}\nPhone: ${snapshot.data?[1].get('phone')}\nOther: ${snapshot.data?[1].get('other_info')}", textAlign: TextAlign.center,)]
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
                                children: [Text("Pharmacy Information:\nName: ${snapshot.data?[2].get('name')}\n${snapshot.data?[2].get('addr')}\n${snapshot.data?[2].get('city')}, ${snapshot.data?[2].get('state')} ${snapshot.data?[2].get('zip')}\n${snapshot.data?[2].get('phone')}", textAlign: TextAlign.center,)]
                            )
                        ),
                      ),
                      SizedBox(
                          height: 25
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Change Language'),
                          onPressed: () => getDoctor(),
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
                      SizedBox(
                          height: 25
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