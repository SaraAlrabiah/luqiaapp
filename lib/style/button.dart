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
      height: size.height * 0.08,
      child: Column(

        children: [
      // SizedBox(
      // width: size.width * 0.1,
      //   height: size.height * 0.0005,),
          ElevatedButton(

            style: ElevatedButton.styleFrom(
              minimumSize: Size(size.width*0.9, size.height*0.07),
              maximumSize: Size(size.width*0.9, size.height*0.07),
              primary: Color.fromRGBO(97,169,165, 1),
              onPrimary: Colors.white,
              //Color.fromRGBO(	83, 83, 83, 1),
              // onPrimary: Color(669999),
              //535353
              // 61A9A5

              padding: EdgeInsets.symmetric(horizontal: size.width *0.03, vertical: size.width * 0.01),
              textStyle: TextStyle(
                  fontSize: size.width *0.04,
                  fontWeight: FontWeight.normal)),
            onPressed: onPressed,
            child: Text(text , textAlign: TextAlign.center,),)
        ],


      ),
    );
  }
}
