// ignore: file_names
// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late TabController _tabController;
  TextEditingController _GroupNameController = TextEditingController(text: "");
  TextEditingController _GroupActivityController =
  TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _GroupNameController = TextEditingController(text: "");
    _GroupActivityController = TextEditingController(text: "");
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
            // ignore: non_constant_identifier_names

           // final uid = currentUser.uid;
            // Dashboard.userDashboard(uid);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Add Group User'),
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  const MainScreen(
                          ),
                        ));
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.cloud_outlined),
                    ),
                  ],
                ),
              ),
              body: TabBarView(controller: _tabController, children: <Widget>[
                Scaffold(
                  body: Form(
                    key: _form,
                    /*SingleChildScrollView(
                  child:  Padding(
                    padding: const EdgeInsets.all(
                        16.0 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,*/
                    child: ListView(children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.03),
                          /*  SvgPicture.asset(
                            "assets/icons/login.svg",
                            height: size.height * 0.35,
                          ),*/
                          SizedBox(height: size.height * 0.03),
                          const SizedBox(height: 100.0),
                          const Text(
                            "Create Group",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _GroupNameController,
                            decoration: const InputDecoration(
                                hintText: "Enter Group Name"),
                            validator: (text) {
                              if (/*!(text!.contains()) &&*/ text!.isNotEmpty) {
                                return "Enter a valid Group name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _GroupActivityController,
                            decoration: const InputDecoration(
                                hintText: "Enter Group Activity"),
                            validator: (text) {
                              if (!(text!.isNotEmpty) && text.isNotEmpty) {
                                return "Enter valid Group Activity";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                              child: const Text("Add"),
                              onPressed: () async {
                                _saveForm();
                                if (_GroupActivityController.text.isEmpty ||
                                    _GroupNameController.text.isEmpty) {
                                  print("Inormation cannot be empty");
                                  return;
                                }

                                try {
                                  GroupOperation.createNewGroup(
                                      id,
                                      _GroupNameController.text,
                                      _GroupActivityController.text,
                                      email!);


                                  print("added successful");
                                                                //       Navigator.pop( context );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MainScreen(),
                                      ));
                                } catch (e) {
                                  print(e);
                                }
                              }),
                        ],
                      ),
                    ]),
                  ),
                )
              ]),
            );
          } else {
            return LoginPage();
          }
        });
  }
}
