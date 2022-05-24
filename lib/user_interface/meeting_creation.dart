
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luqiaapp/main.dart';
import 'package:luqiaapp/user_interface/time_page.dart';
import 'login.dart';
import 'package:luqiaapp/style/button.dart';

class MeetingCreation extends StatefulWidget {



  MeetingCreation({Key? key, this.groupId  }) : super(key: key);
  final  groupId ;


  @override
  // ignore: no_logic_in_create_state
  _MeetingCreationState createState() => _MeetingCreationState(groupId );
}



class _MeetingCreationState extends State<MeetingCreation> with TickerProviderStateMixin {
  var groupId;

  _MeetingCreationState(this.groupId);
  TextEditingController _MeetingTitleController = TextEditingController(text: "");
  TextEditingController _MeetingDescriptionController =
  TextEditingController(text: "");




  @override
  void initState() {
    super.initState();
    _MeetingTitleController = TextEditingController(text: "");
    _MeetingDescriptionController = TextEditingController(text: "");


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
          var currentUser = FirebaseAuth.instance.currentUser;
            var email = currentUser?.email;
            Size size = MediaQuery.of(context).size;
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title:  Text('Create Meeting '.tr,style: TextStyle(
                    color: Colors.black,
                ),),
                leading: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>   MainScreen(
                          ),
                        ));
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black,),
                ),
              ),
              body:
                Scaffold(
                  body: Form(
                    key: _form,

                    child: ListView(
                        children: <Widget>[
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                    SizedBox(height: size.height * 0.10),
                    SizedBox(
                        height: size.height * 0.70,
                        width: size.width * 0.90,
                        child: Card(

                          child: Column(
                            children: [
                            TextFormField(
                              controller: _MeetingTitleController,
                              decoration:  InputDecoration(
                                  hintText: "Enter Meeting Title".tr),
                              validator: (text) {
                                if (/*!(text!.contains()) &&*/ text!.isEmpty) {
                                  return "Enter a valid Meeting Title".tr;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              controller: _MeetingDescriptionController,
                              decoration:  InputDecoration(
                                  hintText: "Enter Meeting Description".tr),
                              validator: (text) {
                                if ( text!.isEmpty) {
                                  return "Enter a valid Meeting Description".tr;
                                }
                                return null;
                              },
                            ),
                             SizedBox(height: size.height * 0.1),
                            Button(onPressed: () async {
                              _saveForm();
                              if (_MeetingDescriptionController.text.isEmpty ||
                                  _MeetingTitleController.text.isEmpty) {
                                return;
                              }

                              try {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>     DatetimePickerWidget(meetingTitle: _MeetingTitleController.text , meetingDescreiption: _MeetingDescriptionController.text, groupId: groupId, email: email,  ),
                                    ));
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            }, text: 'Add'.tr)

                          ],
                        ),
                      ),
                    )
                    ]
                    ),
    ]
                    ),
                  ),
                )
            //   ]
            // ),
            );
          } else {
            return LoginPage();
          }
        });
  }
}

