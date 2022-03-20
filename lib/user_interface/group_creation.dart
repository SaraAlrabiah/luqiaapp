
// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luqiaapp/main.dart';
import 'package:luqiaapp/operation/group_operation.dart';
import 'login.dart';

class GroupUserPage extends StatefulWidget {
  const GroupUserPage({Key? key}) : super(key: key);

  @override
  // ignore: avoid_types_as_parameter_names
  _GroupUserPageState createState() => _GroupUserPageState();
}

class _GroupUserPageState extends State<GroupUserPage>
    with TickerProviderStateMixin {
  // late TabController _tabController;
  final TextEditingController _GroupNameController = TextEditingController(text: "");
  final TextEditingController _GroupActivityController =
  TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 1, vsync: this);
  //  _GroupNameController = TextEditingController(text: "");
  //  _GroupActivityController = TextEditingController(text: "");
  }

  final _form = GlobalKey<FormState>();

//saving form after validation
  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            //  UserHelper.saveUser(snapshot.data!);
            var currentUser = FirebaseAuth.instance.currentUser;
            var id = currentUser!.uid;
            var email = currentUser.email;
            Size size = MediaQuery.of(context).size;

           // final uid = currentUser.uid;
            // Dashboard.userDashboard(uid);

            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.grey,
                title: const Text('Create Group'),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>   MainScreen(
                          ),
                        ));
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              body:
              //TabBarView(controller: _tabController, children: <Widget>[
                Scaffold(
                  body: Form(
                    key: _form,

                    child: ListView(children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.10),
                          SizedBox(
                            height: size.height * 0.5,
                            width: size.width * 0.90,
                            child: Card(

                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _GroupNameController,
                                    decoration:  InputDecoration(
                                        hintText: "Enter Group Name".tr),
                                    validator: (text) {
                                      if (/*!(text!.contains()) &&*/ text!.isEmpty) {
                                        return "Enter a valid Group name".tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.05),
                                  TextFormField(
                                    controller: _GroupActivityController,
                                    decoration: const InputDecoration(
                                        hintText: "Enter Group Activity"),
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Enter valid Group Activity";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.15),
                                  ElevatedButton(
                                      child: const Text("Add"),
                                      onPressed: () async {
                                        _saveForm();
                                        if (_GroupActivityController.text.isEmpty ||
                                            _GroupNameController.text.isEmpty) {
                                          return;
                                        }

                                        try {
                                          GroupOperation.createNewGroup(
                                              id,
                                              _GroupNameController.text,
                                              _GroupActivityController.text,
                                              email!);


                                          if (kDebugMode) {
                                            print("added successful");
                                          }
                                          //       Navigator.pop( context );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>  MainScreen(),
                                              ));
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print(e);
                                          }
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),


                        ],
                      ),
                    ]),
                  ),
                ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
