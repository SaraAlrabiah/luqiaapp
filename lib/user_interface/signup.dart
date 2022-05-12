import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/style/button.dart';
import 'package:luqiaapp/user_interface/user_page.dart';
import 'company_signup.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _firstNameController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");
  TextEditingController _confirmPasswordController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
    _firstNameController = TextEditingController(text: "");
  }

  final _form = GlobalKey<FormState>();

//saving form after validation
  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {

            UserHelper.saveUser(snapshot.data!);
            var currentUser = FirebaseAuth.instance.currentUser;

            final uid = currentUser?.uid;

            return  UserPage(uid: uid,);
          } else {
            Size size = MediaQuery.of(context).size;

            return Scaffold(
              body: Form(
                key: _form,
                child: ListView(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

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
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 50.0 , color:  Color(0xff616161)
                          ),
                      ),
                      SizedBox(
                        width: size.width * 0.85,
                       // height: 750,
                        child: Card(


                          child : Column(
                            children: [
                              TextFormField(
                                controller: _firstNameController,
                                decoration:
                                const InputDecoration(hintText: "Enter your name"),
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Enter a valid name !";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration:
                                const InputDecoration(hintText: "Enter email"),
                                validator: (text) {
                                  if (!(text!.contains('@')) && text.isEmpty) {
                                    return "Enter a valid email address!";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration:
                                const InputDecoration(hintText: "Enter password"),
                                validator: (text) {
                                  if (!(text!.length > 5) && text.isNotEmpty) {
                                    return "Enter valid password of more then 5 characters!";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration:
                                const InputDecoration(hintText: "Confirm password"),
                                validator: (text) {
                                  if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    return "password not match!";
                                  }
                                  return null;
                                },
                              ),
                               SizedBox(height: size.height * 0.05,),
                              Button(onPressed: () async {
                                _saveForm();
                                if (_emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  if (kDebugMode) {
                                    print("Email and password cannot be empty");
                                  }
                                  return;
                                }
                                if (_confirmPasswordController.text.isEmpty ||
                                    _passwordController.text !=
                                        _confirmPasswordController.text) {
                                  print("confirm password does not match");
                                  return;
                                }
                                try {
                                  final user = await AuthHelper.signupWithEmail(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  if (user != null) {
                                    AuthHelper.addName(
                                        _firstNameController.text, user);
                                    UserHelper.saveUser(
                                        user /*, _firstNameController.text */);

                                    print("signup successful");
                                    //       Navigator.pop( context );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>  LoginPage(),
                                        ));
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }, text: "Sign up"),
                              Button(onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginPage(),
                                    ));
                              }, text: "Login"),
                              Button(onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CompanySignupPage(),
                                    ));
                              }, text: "Sign up as company "),
                            ],
                          )

                        ),
                      ),



                    ],
                  ),
                ]),
              ),
            );
          }
        });
  }
}
