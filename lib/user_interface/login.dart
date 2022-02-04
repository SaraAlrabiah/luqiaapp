
import 'package:flutter/material.dart';
import 'package:luqiaapp/operation/auth_helper.dart';
import 'package:luqiaapp/user_interface/signup.dart';

import 'company_signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController(
      text: "" );
  TextEditingController _passwordController = TextEditingController(
      text: "" );

  @override
  final _form = GlobalKey<FormState>();



//saving form after validation
  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  void initState() {
    super.initState(
    );
    _emailController = TextEditingController(
        text: "" );
    _passwordController = TextEditingController(
        text: "" );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form, //assigning key to form

        child: ListView(
          children: <Widget>[

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              validator: (text) {
                if (!(text!.contains('@')) && text.isNotEmpty || text.isEmpty) {
                  return "Enter a valid email address!";
                }
                return null;
              },
            ),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (text) {
                if (!(text!.length > 5) && text.isNotEmpty || text.isEmpty) {
                  return "Enter valid Password of more then 5 characters!";
                }
                return null;
              },

            ),

            ElevatedButton(
                child: const Text('Login'),
                onPressed: () async {
                  _saveForm();
                  try {
                    final user = await AuthHelper.signInWithEmail(
                        email: _emailController.text,
                        password: _passwordController.text );
                    if (user != null) {
                      print(
                          "login successful" );
                    }
                  } catch (e) {
                    print(
                        e );
                  }
                }
            ),
           ElevatedButton(
              child: const Text(
                  "Create Account As Individual" ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SignupPage(
                          ),
                    ) );
              },
            ),
            ElevatedButton(
                child: const Text("Sign up as company "),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanySignupPage(),
                      ));
                }),

          ],
        ),
      ),
      /*SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
              16.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                  height: 100.0 ),
              const Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 20.0 ),
              ),
              const SizedBox(
                  height: 20.0 ),
              /*  RaisedButton(
                child: Text("Login with Google"),
                onPressed: () async {
                  try {
                    await AuthHelper.signInWithGoogle();
                  } catch (e) {
                    print(e);
                  }
                },
              ),*/
              TextFormField(
                validator: (text) {
                  if (!(text!.length > 5) && text.isNotEmpty) {
                    return "Enter valid name of more then 5 characters!";
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Full Name',
                  //  errorText: validator
                ),


              ),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Enter email",

                 // errorText: userNameValidate ? 'Please enter a Username' : null

                  //'Password can\'t be empty',
                ),
              ),
              const SizedBox(
                  height: 10.0 ),
              TextField(
                controller: _passwordController,
                obscureText: true,

                //  validator: (input) => input.isEmpty ? "*Required" : null,
                decoration: const InputDecoration(
                  hintText: "Enter password",
                  // errorText: PasswordErrorText,

                ),
              ),
              const SizedBox(
                  height: 10.0 ),
              RaisedButton(
                child: Text(
                    "Login" ),
                onPressed: () async {
                  /* if (PasswordErrorText == null){

                  }
                 */ if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {

                    print(

                        "Email and password cannot be empty" );
                    return;
                  }
                  try {
                    final user = await AuthHelper.signInWithEmail(
                        email: _emailController.text,
                        password: _passwordController.text );
                    if (user != null) {
                      print(
                          "login successful" );
                    }
                  } catch (e) {
                    print(
                        e );
                  }
                },
              ),
              RaisedButton(
                child: Text(
                    "Create Account" ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SignupPage(
                            ),
                      ) );
                },
              )
            ],
          ),
        ),
      ),*/
    );
  }


}
// ignore: camel_case_types
/*
class LoginPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();

   LoginPage({Key? key}) : super(key: key);

//saving form after validation
  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _form, //assigning key to form

          child: ListView(
            children: <Widget>[

              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (text) {
                  if (!(text!.length > 5) && text.isNotEmpty) {
                    return "Enter valid name of more then 5 characters!";
                  }
                  return null;
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (text) {
                  if (!(text!.contains('@')) && text.isNotEmpty) {
                    return "Enter a valid email address!";
                  }
                  return null;
                },
              ),

              RaisedButton(
                child: const Text('Login'),
                onPressed: () => _saveForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

*/

