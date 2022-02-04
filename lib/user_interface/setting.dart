
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/localization/localization_services.dart';

import '../main.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting>
   // with TickerProviderStateMixin
{

  late String lng;

  @override
  void initState() {
    super.initState();
    lng = LocalizationService().getCurrentLang();

  }


  @override
  Widget build(BuildContext context) {
    /*return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // ignore: non_constant_identifier_names
            var currentUser = FirebaseAuth.instance.currentUser;
            var email = currentUser!.email;
            final uid = currentUser.uid;
            var name = currentUser.displayName;

*/
    var currentUser = FirebaseAuth.instance.currentUser;
    var email = currentUser!.email;
    //final uid = currentUser.uid;
    var name = currentUser.displayName;

    return Scaffold(
              appBar: AppBar(
                title: Text('Luqia'.tr),
                elevation: 0,
                backgroundColor: Colors.grey,
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  const MainScreen(
                          ),
                        ));
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),

              ),
                body:  _uiWidget(name, email!),

            );
          } /*else {
            return LoginPage();
          }*/
       // }
      //  );
  //}

Widget _uiWidget(String? name, String email) {
  var currentUser = FirebaseAuth.instance.currentUser;
  var email = currentUser!.email;
 // final uid = currentUser.uid;
  var name = currentUser.displayName;
  return Column(


    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      const SizedBox( width: 30.0),

      const SizedBox(height:30.0, width: 30.0),
       Text ('               PROFILE'.tr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.grey,),),
      const SizedBox(height:50.0),
      Row(
       children: [

         Text(
           "          Name".tr,
           style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
         ),
         const SizedBox(width:50.0),

         Text(name!),
        ],
      ),
      const SizedBox(height:50.0),

      Row(
        children: [

          Text(
            "          Email".tr,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width:50.0),

          Text(email!),
        ],
      ),
      const SizedBox(height:50.0),


      Row(

        children: [
          Text(
            "          Language".tr,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width:50.0),
          DropdownButton<String>(
            items: LocalizationService.langs.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: lng,
            underline: Container(color: Colors.transparent),
            isExpanded: false,
            onChanged: (newVal) {
              setState(() {
                lng = newVal!;
                LocalizationService().changeLocale(newVal);
                print(newVal);
              });
            },
          ),
        ],
      )
    ],
  );
}
}
