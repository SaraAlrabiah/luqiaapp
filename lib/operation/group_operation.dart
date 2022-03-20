import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_helper.dart';

class GroupOperation {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static int groupId (int groupNum){
    return groupNum;

  }
  static Future<void> createNewGroup(String currentUserId,String groupName,
      String groupActivity,String userEmail) async {
    AdminTrack.usersTrack(  userEmail , 'Create a group' , DateTime.now());
    // Add user to current user's following collection
    QuerySnapshot groupCollection = await db
        .
    collection('Group')
        .get();
    int groupCount = groupCollection.size;
    int groupNum = groupCount++;
    String groupNumber = groupNum.toString();
    Map<String, dynamic> groupInfo = {
      'groupId':  groupNumber,
      'CreateById': currentUserId,
      'CreateByEmail': userEmail,
      'GroupName': groupName,
      'GroupActivity': groupActivity
    };
    db

        .collection(
        'Group' ).doc(groupNumber).set(groupInfo);
    //// part to add group to creator page
    db
        .collection(
        "users" )
        .doc(
        currentUserId )
        .collection(
        'Group' ).doc(groupNumber).set(groupInfo);
    GroupOperation.addGroupMember(  groupNumber ,    currentUserId, userEmail);


  }
  static Future<void> addNewUser( String userID, String userEmail ,  String groupID , String groupName, String groupActivity, String currentUserId,String currentUserEmail ) async {

    Map<String, dynamic> groupInfo = {
      'groupId':  groupID,
      'CreateById': userID,
      'CreateByEmail': userEmail,
      'GroupName': groupName,
      'GroupActivity': groupActivity

    };
      db.collection( "users" ).doc( currentUserId ).collection('Group').doc(groupID).set(groupInfo);

  }
  /*static Future<void> AddNewUser(String userID,String userEmail,
      String GroupID , String groupName, String groupActivity ,String currentUserId,String currentUserEmail,) async {
    // Add user to current user's following collection
    final Group = db.collection("Group").doc(GroupID).get();
    final userRef = db
        .collection("users")
        .doc(currentUserId)
        .collection("Group")
        .doc(GroupID);
    // ignore: non_constant_identifier_names
    Map<String, dynamic> GroupInfo = {
      'groupId':  GroupID,
      'CreateById': userID,
      'CreateByEmail': userEmail,
      'GroupName': groupName,
      'GroupActivity': groupActivity

    };

      db
          .collection( "users" ).doc( userID ).collection( "Group" ).doc(GroupID).set(GroupInfo);




     Map<String, dynamic> groupDec = {
        'email': userEmail,
        'id': userID,
      };

      db
          .collection("Group")
          .doc(GroupID).collection("GroupMember").add(groupDec);

  }*/
  static Future<void> addGroupMember(  String GroupID  , String currentUserId,String currentUserEmail ) async {
    Map<String, dynamic> groupDec = {
      'email': currentUserEmail,
      'id': currentUserId,
    };

    db
        .collection(
        "Group" )
        .doc(
        GroupID ).collection(
        'GroupMember' ).doc(
    ).set(
        groupDec );
  }



  static Future<void> reqAddNewUser( String userID, String userEmail ,  String GroupID , String groupName, String groupActivity, String currentUserId,String currentUserEmail ) async {

    // Add user to current user's following collection
    //final group = db.collection("Group").doc(GroupID).get();
    final userRef = db
        .collection("users")
        .doc(userID)
        .collection('Group')
        .doc(GroupID);
    // ignore: non_constant_identifier_names
    Map<String, dynamic> GroupInfo = {
      'groupId':  GroupID,
      'CreateById': currentUserId,
      'CreateByEmail': currentUserEmail,
      'GroupName': groupName,
      'GroupActivity': groupActivity

    };
    if ((await userRef.get()).exists) {
      print("the user is already followed"); // error message
    }
    else{
      db
          .collection( "users" ).doc( userID ).collection( 'GroupReq' ).doc(GroupID).set(GroupInfo);

    }

    // db.collection('users').doc(userID).collection('Group').doc(GroupID).collection(userEmail).add(GroupInfo);


  }
  static deleteGroupReq(String uid, String documentId) async {
    db.collection("users").doc(uid).collection('GroupReq').doc(documentId).delete();
  }
}