// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luqiaapp/operation/group_operation.dart';

import '../main.dart';
import 'login.dart';

class GroupPage extends StatefulWidget {


  // ignore: non_constant_identifier_names
  const GroupPage( {Key? key, required this.groupId , required this.groupName, required this.groupActivity}) : super(key: key);

  final  groupId ;
  final groupName;

  // ignore: non_constant_identifier_names
  final groupActivity;
  @override
  // ignore: no_logic_in_create_state
  _GroupPageState createState() => _GroupPageState(groupId ,groupName , groupActivity );
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {

  var groupId;
  var groupName;
  var groupActivity;
  _GroupPageState(this.groupId,this. groupName, this.groupActivity );


  @override
  void initState() {
    super.initState();

  }

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser!.uid;
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white70,
                shadowColor: Colors.black26,
                backgroundColor: Colors.white,
                title: Text('Users'.tr ,style: TextStyle(color: Colors.black),),
                leading: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>   MainScreen(
                          ),
                        ));
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                ),

              ),
              body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection("followingUser")
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
                               // final users = docs[index].data();
                              //  final userDoc = snapshot.data;
                               // final userInfo = userDoc;
                                // ignore: prefer_const_constructors
                                if (snapshot.hasData && snapshot.data != null) {
                                  return ListTile(
                                    leading: const Icon(Icons.group),

                                    title: Text(document['email']),
                                    // subtitle: Text(document['role'])  ,
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add),
                                      tooltip: 'add this user',
                                      onPressed: () async {

                                        final uid = currentUser.uid;
                                        final currentUserEmail = currentUser.email;
                                        final userEmail = document['email'];
                                        final userId = document['id'];
                                        GroupOperation.reqAddNewUser( userId, userEmail!, groupId , groupName ,groupActivity , uid ,  currentUserEmail!);

                                      },
                                    ),

                                  );
                                } else {
                                  return Center(child: Row());
                                }
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      // ignore: deprecated_member_use

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
