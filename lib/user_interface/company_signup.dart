import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/style/button.dart';
import 'package:luqiaapp/user_interface/user_page.dart';
import 'login.dart';

class CompanySignupPage extends StatefulWidget {
  @override
  _CompanySignupPage createState() => _CompanySignupPage();
}

class _CompanySignupPage extends State<CompanySignupPage> {
  TextEditingController _emailController = TextEditingController(text: "");

  TextEditingController _passwordController = TextEditingController(text: "");
  TextEditingController _confirmPasswordController =
      TextEditingController(text: "");

  TextEditingController _companySpecificationController =
      TextEditingController(text: "");
  TextEditingController _companyNameController =
      TextEditingController(text: "");
  TextEditingController _companyAddressController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
    _companySpecificationController = TextEditingController(text: "");

    _companyNameController = TextEditingController(text: "");
    _companyAddressController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var currentUser = FirebaseAuth.instance.currentUser;

            final uid = currentUser?.uid;
            UserHelper.saveUserCompany(snapshot.data!);
            return UserPage(uid: uid);
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: size.width * 0.25,
                        child: CircleAvatar(
                          radius: size.width * 0.20,
                          backgroundColor: Colors.greenAccent,
                          backgroundImage: AssetImage('assets/Logo.jpg'),
                        ),
                      ),
                      SizedBox(height: size.height *0.03,),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Color(0xff616161)),
                      ),
                      SizedBox(height: size.height *0.03,),
                      SizedBox(
                        width: size.width * 0.85,
                        // height: 750,
                        child: Card(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    hintText: "Enter email Company"),
                                validator: (text) {
                                  if (!(text!.contains('@')) &&
                                      text.isNotEmpty) {
                                    return "Enter a valid email address!";
                                  }
                                  return null;
                                },
                              ),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration:
                                    InputDecoration(hintText: "Enter password"),
                              ),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Confirm password"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.85,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Company Information",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Color(0xff616161)),
                                  ),
                                ],
                              ),
                              TextField(
                                controller: _companySpecificationController,
                                decoration: const InputDecoration(
                                    hintText: "Company specification"),
                              ),
                              TextField(
                                controller: _companyNameController,
                                decoration: const InputDecoration(
                                    hintText: "Company name"),
                              ),
                              TextField(
                                controller: _companyAddressController,
                                decoration: const InputDecoration(
                                    hintText: "company Address"),
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              Button(
                                  onPressed: () async {
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      print(
                                          "Email and password cannot be empty");
                                      return;
                                    }
                                    if (_confirmPasswordController
                                            .text.isEmpty ||
                                        _passwordController.text !=
                                            _confirmPasswordController.text) {
                                      // ignore: avoid_print
                                      print("confirm password does not match");
                                      return;
                                    }
                                    try {
                                      final user =
                                          await AuthHelper.signupWithEmail(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                      if (user != null) {
                                        AuthHelper.addName(
                                            _companyNameController.text, user);
                                        UserHelper.companyInfo(
                                            user,
                                            _companyNameController.text,
                                            _companySpecificationController
                                                .text,
                                            _companyAddressController.text);

                                        print("signup successful");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => LoginPage(),
                                            ));
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  text: "Sign up"),
                              Button(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginPage(),
                                        ));
                                  },
                                  text: "Login")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
