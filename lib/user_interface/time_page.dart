import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';

import '../main.dart';
class DatetimePickerWidget extends StatefulWidget {
  const DatetimePickerWidget({Key? key, this.meetingTitle, this.meetingDescreiption, this.groupId, this.email,  }) : super(key: key);

  final groupId;
  final email;
  final meetingTitle;
  final meetingDescreiption;

  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState(meetingTitle, meetingDescreiption,groupId,email);
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {


  DateTime dateTime = DateTime.now(
  );
  final initialDate = DateTime.now(
  );

  _DatetimePickerWidgetState(this.meetingTitle, this.meetingDescreiption,this.groupId,this.email);

  var meetingTitle;
  var meetingDescreiption;
  var groupId;
  var email;


  String getText() {
    if (dateTime == initialDate) {
      return 'Select DateTime';
    } else {
      var x = DateFormat(
          'MM/dd/yyyy HH:mm' ).format( dateTime );


      return x;
    }
  }

  @override
  Widget build(BuildContext context) {
   // print(dateTime);
   // print(groupId);
   return Scaffold(
     appBar: AppBar(
       title: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Text(
               'Select Time'.tr,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 25.0),
             ),

           ]),
       actions: <Widget>[
         IconButton(
           icon: const Icon(Icons.add),
           tooltip: 'Add',
           onPressed: () {

             MeetingOperation.addMeetingTime(meetingTitle, meetingDescreiption, groupId, dateTime , email);

             Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (_) =>  const MainScreen(
                   ),
                 ));
           },
         ),
       ],


     ),
     body: Column(
     children: [
       ElevatedButton(
           child: const Text("Create"),
           onPressed: () {
             MeetingOperation.addMeetingTime(meetingTitle, meetingDescreiption, groupId, dateTime , email);


           }),
       ButtonHeaderWidget(
     title: 'DateTime',
     text: getText(
     ),
     onClicked: () =>
         pickDateTime(
             context ),
   ),


    ],
     ),
   );

  }
    Future pickDateTime(BuildContext context) async {
      final date = await pickDate(
          context );
      if (date == null) return;

      final time = await pickTime(
          context );
      if (time == null) return;

      setState(
              () {
            dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          } );
    }

    Future<DateTime?> pickDate(BuildContext context) async {
  //    final initialDate = DateTime.now( );
      final newDate = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(
            DateTime
                .now(
            )
                .year - 5 ),
        lastDate: DateTime(
            DateTime
                .now(
            )
                .year + 5 ),
      );

      if (newDate == null) return null;

      return newDate;
    }

    Future<TimeOfDay?> pickTime(BuildContext context) async {
      const initialTime = TimeOfDay(
          hour: 12,minute: 0 );
      final newTime = await showTimePicker(
        context: context,
        initialTime: dateTime != null
            ? TimeOfDay(
            hour: dateTime.hour,minute: dateTime.minute )
            : initialTime,
      );

      if (newTime == null) return null;

      return newTime;
    }
  }


class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({

    required this.title,
    required this.text,
    required this.onClicked,
  }) ;

  Widget build(BuildContext context) => HeaderWidget(
    title: title,
    child: ButtonWidget(
      text: text,
      onClicked: onClicked,
    ),
  );

}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({

    required this.text,
    required this.onClicked,
  }) ;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(40),
      primary: Colors.white,
    ),
    child: FittedBox(
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
    ),
    onPressed: onClicked,
  );
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const HeaderWidget({

    required this.title,
    required this.child,
  }) ;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}
