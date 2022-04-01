import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminTrack {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  static usersTrack(String email, String Action, DateTime date) async {
    DateTime now = DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();
    String time = now.hour.toString();
    if (email != 'Admin@gmail.com') {
      Map<String, dynamic> userData = {
        'createdBy': email,
        'Action': Action,
        'day': day,
        'time': time,
        'month': month,
      };
      await db
          .collection("users")
          .doc('usersTrack')
          .collection('usersTrack')
          .add(userData);
    }
  }
}

class AuthHelper {
  static FirebaseAuth db = FirebaseAuth.instance;

  static signInWithEmail(
      {required String email, required String password}) async {
    final res =
        await db.signInWithEmailAndPassword(email: email, password: password);
    // await db.signInWithPhoneNumber(email);
    AdminTrack.usersTrack(email, 'Login In', DateTime.now());
    final User? user = res.user;

    return user;
  }

  static passwordReset(
      {required String email, required String password}) async {
    final user = db.currentUser;
    AdminTrack.usersTrack(email, 'Reset password account', DateTime.now());
    await db.sendPasswordResetEmail(email: email);

    // final User? user = res.user;
    return user;
  }

  static addName(String name, User user) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  static signupWithEmail(
      {required String email, required String password}) async {
    final res = await db.createUserWithEmailAndPassword(
        email: email, password: password);

    //logOut();
    if (email != 'Admin@gmail.com') {
      AdminTrack.usersTrack(email, 'Create an account', DateTime.now());
    }

    final User? user = res.user;

    return user;
  }

  static logOut() {
    final user = db.currentUser!.email;

    AdminTrack.usersTrack(user!, 'Login out', DateTime.now());
    return db.signOut();
  }
}

class UserHelper {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static void userAccept(String currentUserId, String visitedUserId,
      String currentEmail, String userEmail) {
    // Add user to current user's following collection
    Map<String, dynamic> followDec = {
      'email': userEmail,
      'id': visitedUserId,
    };

    Map<String, dynamic> follower = {
      'email': currentEmail,
      'id': currentUserId,
    };

    db
        .collection("users")
        .doc(visitedUserId)
        .collection('followingUser')
        .doc(currentEmail)
        .set(follower);
    db
        .collection("users")
        .doc(currentUserId)
        .collection('followingUser')
        .doc(userEmail)
        .set(followDec);
  }

  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser!).uid;
  }

  Future getCurrentUser() async {
    return _firebaseAuth.currentUser!;
  }

  static followUser(String currentUserId, String visitedUserId,
      String currentEmail, String userEmail) async {
    final userRef = db
        .collection("users")
        .doc(currentUserId)
        .collection('followingUser')
        .doc(userEmail);
    if ((await userRef.get()).exists) {
      print("the user is already followed"); // error message
    } else {
      // add the user
      Map<String, dynamic> followDec = {
        'email': currentEmail,
        'id': currentUserId,
      };

      db
          .collection("users")
          .doc(visitedUserId)
          .collection('Req')
          .add(followDec);
    }
  }

  static userUnfollow(String uid, String followe) async {
    db
        .collection("users")
        .doc(uid)
        .collection('followingUser')
        .doc(followe)
        .delete();
  }

  static delete(String uid, String documentId) async {
    db.collection("users").doc(uid).collection('Req').doc(documentId).delete();
  }

  static deleteFollow(String currentUserId, String visitedUserId,
      String currentEmail, String userEmail) async {
    db
        .collection("users")
        .doc(visitedUserId)
        .collection('followingUser')
        .doc(currentEmail)
        .delete();
    db
        .collection("users")
        .doc(currentUserId)
        .collection('followingUser')
        .doc(userEmail)
        .delete();
  }

  static saveAdmin(
    User? user,
  ) async {
    DateTime now = DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();
    Map<String, dynamic> userData = {
      'name': user?.displayName,
      'id': user!.uid,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
      "role": "admin",
    };
    final userRef = db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
        "last_login_month": month,
        "last_login_day": day,
      });
    } else {
      await db.collection("users").doc(user.uid).set(userData);
    }
    // await _saveDevice(user);
  }

  static saveUser(
    User? user,
    /*String name*/
  ) async {
    DateTime now = DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();

    Map<String, dynamic> userData = {
      'name': user?.displayName,
      'id': user!.uid,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      "last_login_month": month,
      "last_login_day": day,
      "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
      "role": "normalUser",
      'CurrentLocationLat': '',
      'CurrentLocationLng': '',
    };
    final userRef = db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        'name': user.displayName,
        "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
        "last_login_month": month,
        "last_login_day": day,
      });
    } else {
      await db.collection("users").doc(user.uid).set(userData);
    }
    // await _saveDevice(user);
  }

  static companyInfo(User user, String companyName, String companySpecification,
      String companyAddress) async {
    DateTime now = DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();
    Map<String, dynamic> userData = {
      'id': user.uid,
      'name': companyName,
      'companyAddress': companyAddress,
      "companySpecification": companySpecification,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      "last_login_month": month,
      "last_login_day": day,
      "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
      "role": "companyUser",
    };
    await db.collection("users").doc(user.uid).set(userData);
    // }
    await user.updateDisplayName(companyName);
  }

  static saveUserCompany(User? user) async {
    DateTime now = DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();

    final userRef = db.collection("users").doc(user?.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user?.metadata.lastSignInTime!.millisecondsSinceEpoch,
        "last_login_month": month,
        "last_login_day": day,
      });
    }
  }

/*
   static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String deviceId;
    Map<String, dynamic> deviceData;
    if (Platform.supportsTypedData) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }
  }*/
}
