import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class Dashboard {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> usersCount(String uid) async {
    QuerySnapshot companyUsersCollection = await db
        .collection('users')
        .where('role', isEqualTo: 'companyUser')
        .get();
    int companyUsersCount = companyUsersCollection.size;

    DateTime now = DateTime.now();
    String month = now.month.toString();
    // ignore: non_constant_identifier_names
    QuerySnapshot ActiveUsersCollection = await db
        .collection('users')
        .where('last_login_month', isEqualTo: month )//.where('role', isNotEqualTo: 'admin' )
        .get();
    // ignore: non_constant_identifier_names
    int ActiveUsersCount = ActiveUsersCollection.size -1;
    if(ActiveUsersCount < 0){
      ActiveUsersCount == 0;
    }
    String day = now.day.toString();
    QuerySnapshot todayActiveUsersCollection = await db
        .collection('users')
        .where('last_login_day', isEqualTo: day  )
        .get();
    int todayActiveUsersCount = todayActiveUsersCollection.size -1 ;
    if(todayActiveUsersCount < 0){
      todayActiveUsersCount == 0;
    }

    QuerySnapshot normalUserCollection = await db
        .collection('users')
        .where('role', isEqualTo: 'normalUser')
        .get();
    int normalUserCount = normalUserCollection.size ;
    // userCounty(normalUserCount);
    Map<String, dynamic> dashboardDataUser = {
      'users': normalUserCount.toString(),
      'company': companyUsersCount.toString(),
      'activeUser': ActiveUsersCount.toString(),
      'todayActiveUser': todayActiveUsersCount.toString()
    };
    db
        .collection("users")
        .doc(uid)
        .collection('Dashboard')
        .doc(uid)
        .delete();
    db
        .collection("users")
        .doc(uid)
        .collection('Dashboard')
        .doc(uid)
        .set(dashboardDataUser);
  //  await db.collection("users").doc(uid).collection('dashboard').delete();
   // await db.collection("users").doc(uid).collection('dashboard').add(dashboardDataUser);
  }

  static Future<void> userDashboard(String uid) async {
    QuerySnapshot usersCollection = await db
        .collection('users')
        .doc(uid)
        .collection('followingUser')
    // .where('role', isEqualTo: 'companyUser')
        .get();
    int usersInfoCount = usersCollection.size;
    if (kDebugMode) {
      print('followers $usersInfoCount');
    }
    QuerySnapshot reqCollection = await db
        .collection('users')
        .doc(uid)
        .collection('Req')
        .get();
    int reqCollectionCount = reqCollection.size;
    if (kDebugMode) {
      print('Req $reqCollectionCount');
    }

    Map<String, dynamic> dashboardDataUser = {
      'userFollowing': usersInfoCount.toString(),
      'userReq': reqCollectionCount.toString()
    };
    db
        .collection("users")
        .doc(uid)
        .collection('userDashboard')
        .doc(uid)
        .delete();
    db
        .collection("users")
        .doc(uid)
        .collection('userDashboard')
        .doc(uid)
        .set(dashboardDataUser);

  }
}
