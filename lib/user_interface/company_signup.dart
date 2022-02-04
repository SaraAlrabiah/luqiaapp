import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'company_page.dart';
import 'login.dart';

class CompanySignupPage extends StatefulWidget {
  @override
  _CompanySignupPage createState() => _CompanySignupPage();
}

class _CompanySignupPage extends State<CompanySignupPage> {
  TextEditingController _emailController = TextEditingController(text: "");

  TextEditingController _passwordController = TextEditingController(text: "");
  TextEditingController _confirmPasswordController = TextEditingController(text: "");

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
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUserCompany(snapshot.data!);
            return const CompanyUserPage();
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 100.0),
                       Text(
                        "Sign Up".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      const SizedBox(height: 20.0),
                      /*   RaisedButton(
                child: Text("Continue with Google"),
                onPressed: () async {
                  try {
                    await AuthHelper.signInWithGoogle();
                  } catch (e) {
                    print(e);
                  }
                },
              ),*/
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            hintText: "Company Enter email"),
                        validator: (text) {
                          if (!(text!.contains('@')) && text.isNotEmpty) {
                            return "Enter a valid email address!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration:
                        const InputDecoration(hintText: "Enter password"),
                      ),
                      const SizedBox(height: 10.0),

                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration:
                        const InputDecoration(hintText: "Confirm password"),
                      ),
                      const SizedBox(height: 40.0),
                      const Text(
                        "Company Information",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      const SizedBox(height: 10.0),

                      TextField(
                        controller: _companySpecificationController,
                        decoration: const InputDecoration(
                            hintText: "Company specification"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _companyNameController,
                        decoration:
                        const InputDecoration(hintText: "Company name"),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _companyAddressController,
                        decoration:
                        const InputDecoration(hintText: "company Address"),
                      ),
                      const SizedBox(height: 10.0),

                      ElevatedButton(
                        child: const Text("Sign up"),
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            print("Email and password cannot be empty");
                            return;
                          }
                          if (_confirmPasswordController.text.isEmpty ||
                              _passwordController.text !=
                                  _confirmPasswordController.text) {
                            // ignore: avoid_print
                            print("confirm password does not match");
                            return;
                          }
                          try {
                            final users = await AuthHelper.signupWithEmail(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            print(users);
                            if (users != null) {
                              UserHelper.companyInfo(users , _companyNameController.text, _companySpecificationController.text, _companyAddressController.text );
                              print(users);
                              print("signup successful");
                              //       Navigator.pop( context );
                              AuthHelper.logOut();
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
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                          child: const Text("Login in"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginPage(),
                                ));
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
