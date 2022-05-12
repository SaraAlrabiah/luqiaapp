
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/main.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/operation/dashboard.dart';
import 'package:luqiaapp/operation/location_operation.dart';
import 'package:provider/provider.dart';
import 'login.dart';
class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key, required uid}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> with TickerProviderStateMixin {

  var currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var currentUser = FirebaseAuth.instance.currentUser;
            UserHelper.saveUser(currentUser);
            final uid = currentUser!.uid;
            var email = currentUser.email;
            Dashboard.userDashboard(uid,email! );
            var name = currentUser.displayName;
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      Text('    $name', style:const TextStyle(
                          color: Colors.black,
                          fontSize: 25.0), ),
                    ]),
                leading: IconButton(
                  color: Colors.black,
                  onPressed: () {

                    Navigator.pop( context,MaterialPageRoute(builder: (context) =>   MainScreen()), );
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                ),
                actions: <Widget>[
                  IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () {
                      AuthHelper.logOut();
                    },
                  ),
                ],

              ),
              body:
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final docs = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                                  final users = docs[index].data();
                                  final uid = currentUser.uid;
                                  if ((users as Map<String, dynamic>)['role'] ==
                                      'normalUser' &&
                                      (users)['id'] !=
                                          currentUser
                                              .uid ) {
                                    return ListTile(
                                      selectedColor: Colors.blue,
                                      textColor: Colors.green,

                                      title: Text(document['email']),
                                      subtitle: Text(document['role']),
                                      trailing: IconButton(
                                        icon:  const Icon(
                                          Icons.add,
                                        ),
                                        tooltip: 'add this user',
                                        onPressed: () async {
                                          final email = currentUser.email;
                                          final userId = document['id'];
                                          final userEmail = document['email'];

                                          UserHelper.followUser(
                                              uid, userId, email!, userEmail);

                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(child: Row());
                                  }
                                },
                              );
                            } else {
                              return Center(child: Row());
                            }
                          },
                        ),

                      ],
                    ),
                  ),



            );
          } else {
            return LoginPage();
          }
        });
  }
}
