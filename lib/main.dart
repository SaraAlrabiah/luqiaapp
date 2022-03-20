import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:luqiaapp/user_interface/admin_page.dart';
import 'package:luqiaapp/user_interface/login.dart';
import 'package:luqiaapp/user_interface/user_page.dart';
import 'package:provider/provider.dart';
import 'localization/localization_services.dart';
import 'operation/auth_helper.dart';
import 'operation/location_operation.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp( const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp())
 );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LocationProvider(),

          )
        ],
    child: GetMaterialApp(
      title: 'Luqia'.tr,
      debugShowCheckedModeBanner: false,
      translations: LocalizationService(), // your translations
      locale: LocalizationService()
          .getCurrentLocale(), // translations will be displayed in that locale
      fallbackLocale: const Locale
          ('en', 'US'),  // specify the fallback locale in case an invalid locale is selected.
      home:  const MainScreen(),
    )
    );
  }
}
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).initialization();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
                UserHelper.saveUser(snapshot.data!);
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {

                if (snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  var currentUser = FirebaseAuth.instance.currentUser;
                  final uid = currentUser?.uid;

                  final user = userDoc!.data();
                  if ((user as Map<String, dynamic>)['role'] == 'admin') {
                    return const AdminPage();
                  } else if ((user)['role'] == 'normalUser') {
                    return  UserPage(uid: uid,);
                  } else if ((user)['role'] == 'companyUser') {
                    return UserPage(uid: uid,);
                    // const CompanyUserPage();
                  } else {
                    return LoginPage();
                  }
                } else {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
          return LoginPage();
        }
    );
  }
}

