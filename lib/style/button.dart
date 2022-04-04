import 'package:flutter/material.dart';

class Button extends StatelessWidget {


  Button({@required this.onPressed ,required this.text });

  final String text;

  final  onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.5,
      height: size.height * 0.3,
      child: Column(
        children: [
      SizedBox(
      width: size.width * 0.1,
        height: size.height * 0.05,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(97,169,165, 1),
              onPrimary: Color.fromRGBO(	83, 83, 83, 1),
              // onPrimary: Color(669999),
              //535353
              // 61A9A5

              padding: EdgeInsets.symmetric(horizontal: size.width *0.01, vertical: size.width * 0.05),
              textStyle: TextStyle(
                  fontSize: size.width *0.05,
                  fontWeight: FontWeight.bold)),
            onPressed: onPressed,
            child: Text(text),)
        ],


      ),
    );
  }
}
