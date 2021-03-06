import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/style/button.dart';
import 'package:luqiaapp/user_interface/signup.dart';

import 'company_signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");

  @override
  final _form = GlobalKey<FormState>();

  bool notvalid = false;


//saving form after validation
  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _form,

        child: ListView(
          children: <Widget>[
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: size.width * 0.35,
                  child: CircleAvatar(
                    radius: size.width * 0.30,
                    backgroundColor: Colors.greenAccent,
                    backgroundImage: AssetImage('assets/Logo.jpg'),
                  ),
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0,
                      color: Color(0xff616161)),
                ),
                SizedBox(
                  width: size.width * 0.85,
                  // height: 750,
                  child: Card(
                    child: Column(
                      children: [
                        Text(notvalid ? 'User not found' : ' '),


                        TextFormField(
                          controller: _emailController,

                          decoration:
                              const InputDecoration(labelText: 'Email Address' ,  ),
                          validator: (text) {
                            if (!(text!.contains('@')) && text.isNotEmpty ||
                                text.isEmpty) {
                              return "Enter a valid email address!";
                            }

                            return null;


                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          validator: (text) {
                            if (!(text!.length > 5) && text.isNotEmpty ||
                                text.isEmpty) {
                              return "Enter valid Password of more then 5 characters!";
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),


                        Button(
                            onPressed: () async {

                              _saveForm();
                              try {
                                final user = await AuthHelper.signInWithEmail(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                print(user);

                                if (user != null) {

                                  print("login successful");
                                }

                              } catch (e) {
                                print(e);
                              }
                            },
                            text: 'Login'),
                        Button(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupPage(),
                                  ));
                            },
                            text: "Sign up as individual"),
                        // SizedBox(
                        //   height: size.height * 0.03,
                        // ),
                        Button(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompanySignupPage(),
                                  ));
                            },
                            text: "Sign up as company ")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
