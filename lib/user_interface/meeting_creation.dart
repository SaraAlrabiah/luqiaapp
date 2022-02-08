
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/main.dart';
import 'package:luqiaapp/user_interface/setting.dart';
import 'login.dart';

class MeetingCreation extends StatefulWidget {
  const MeetingCreation({Key? key}) : super(key: key);

  @override
  // ignore: avoid_types_as_parameter_names
  _MeetingCreationState createState() => _MeetingCreationState();
}

class _MeetingCreationState extends State<MeetingCreation>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _GroupNameController = TextEditingController(text: "");
  TextEditingController _GroupActivityController =
  TextEditingController(text: "");
 // TextEditingController _DateController = TextEditingController(text: "");
 // TextEditingController _LocationController = TextEditingController(text: "");


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _GroupNameController = TextEditingController(text: "");
    _GroupActivityController = TextEditingController(text: "");
   // _DateController = TextEditingController(text: "");
  //  _LocationController = TextEditingController(text: "");

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
      //    var currentUser = FirebaseAuth.instance.currentUser;
           // var id = currentUser!.uid;
           // var email = currentUser.email;
            Size size = MediaQuery.of(context).size;

            // final uid = currentUser.uid;
            // Dashboard.userDashboard(uid);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Create Meeting '),
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

                    child: ListView(
                        children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.03),
                         /* SvgPicture.asset(
                            "assets/icons/login.svg",
                            height: size.height * 0.35,
                          ),*/
                          SizedBox(height: size.height * 0.03),
                          const SizedBox(height: 100.0),
                          const Text(
                            "Create Meeting",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _GroupNameController,
                            decoration: const InputDecoration(
                                hintText: "Enter Meeting Title"),
                            validator: (text) {
                              if (/*!(text!.contains()) &&*/ text!.isEmpty) {
                                return "Enter a valid Meeting Title";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _GroupActivityController,
                            decoration: const InputDecoration(
                                hintText: "Enter Meeting Description"),
                            validator: (text) {
                              if ( text!.isEmpty) {
                                return "Enter a valid Meeting Description";
                              }
                              return null;
                            },
                          ),
                          Row(

                           children:  [
                            IconButton(

                              icon: const Icon(Icons.date_range_rounded),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Setting()),
                                );
                              },
                            ),
                             const Text('Meeting Date', style: TextStyle(
                                 fontWeight: FontWeight.bold, fontSize: 20.0),),


                           ],
                          ), Row(

                            children:  [
                              IconButton(

                                icon: const Icon(Icons.location_on_outlined),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Setting()),
                                  );
                                },
                              ),
                              const Text('Meeting Location', style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),),


                            ],
                          ),
                          const SizedBox(height: 10.0),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                              child: const Text("Add"),
                              onPressed: () async {
                                _saveForm();
                                if (_GroupActivityController.text.isEmpty ||
                                    _GroupNameController.text.isEmpty) {
                                  return;
                                }

                                try {
                                  /*GroupOperation.createNewGroup(
                                      id,
                                      _GroupNameController.text,
                                      _GroupActivityController.text,
                                      email!);
*/

                                  if (kDebugMode) {
                                    print("added successful");
                                  }
                                  //       Navigator.pop( context );
                                  Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MainScreen(),
                                      ));
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
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

