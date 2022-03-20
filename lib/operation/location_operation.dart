
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  BitmapDescriptor? _pinLocationIcon;
  BitmapDescriptor? get pinLocationIcon => _pinLocationIcon;
  Map<MarkerId, Marker>? _marker;
  Map<MarkerId, Marker>? get marker => _marker;

  final MarkerId markerId = const MarkerId("1");

  Location? _location;
  Location? get location => _location;
  LatLng? _locationPosition;
  LatLng? get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = Location();
  }

  initialization() async {
    print('here3');
    await getUserLocation();
    await setCustomMapPin();
  }

getUserLocation() async {
    bool _serviceEnable;
    PermissionStatus _permissionGranted;
    print('here4');


    _serviceEnable = await location!.serviceEnabled();
    if (!_serviceEnable) {
      _serviceEnable = await location!.requestService();

      if (!_serviceEnable) {
        return;
      }
    }


    _permissionGranted = await location!.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location!.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return ;
      }
    }

    location!.onLocationChanged.listen((LocationData currentLocation) async {
      _locationPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      print('start');
      var currentUser = FirebaseAuth.instance.currentUser;
      final userRef = db.collection("users").doc(currentUser?.uid);
      if(currentUser?.uid != null){
    if ((await userRef.get()).exists) {
      await userRef.update(
          {
            'CurrentLocationLat': _locationPosition?.latitude,
            'CurrentLocationLng': _locationPosition?.longitude,
          } );
    }
    }

      _marker = <MarkerId, Marker>{};
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        //icon: (pinLocationIcon)!,
        draggable: true,
        onDragEnd: ((newPosition)  {
          _locationPosition =
              LatLng(newPosition.latitude, newPosition.longitude);
          notifyListeners();
          print(_locationPosition);
        }),
      );

      _marker![markerId] = marker;
      notifyListeners();
    });
  }

  setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pin1.png',
    );
  }
}

class LocationService {
  static const String key = 'AIzaSyAOD1C-k5VpLbQ7fDH3-OVDaFGgh3BzUkc';
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static estimatedTime (String meetingId , String userId ) async {
    final meetingRef = db.collection("Meetings");
    var currentUser = FirebaseAuth.instance.currentUser;
    final userRef = db.collection("users");
    DocumentSnapshot snapshot = await meetingRef.doc(meetingId).get();
    DocumentSnapshot userSnapshot = await userRef.doc(userId).get();
   var groupId;
    var meetingData = snapshot.data() as Map;
    var userData = userSnapshot.data() as Map;
    groupId = meetingData['GroupId'];
    print('group Id $groupId');
    var meetingTime = meetingData['MeetingDate'];
    print('meeting Time $meetingTime');
    var meetingLocationLat = meetingData['MeetingLocationLat'];
    var meetingLocationLng = meetingData['MeetingLocationLng'];
    var userLocationLat = userData['CurrentLocationLat'];
    var userLocationLng= userData['CurrentLocationLng'];
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$userLocationLat,$userLocationLng&destination=$meetingLocationLat,$meetingLocationLng&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(
        response.body );
    var result ={
     /* 'bounds_ne':json['routes'][0]['bounds']['northeast'] ,
      'bounds_sw': json['routes'][0]['bounds']['southwest'] ,
      'start_location' : json['routes'][0]['legs'][0]['start_location'] ,
      'end_location' : json['routes'][0]['legs'][0]['end_location'] ,
      'travel_mode': json['routes'][0]['legs'][0]['travel_mode'] ,
      'polyline':json['routes'][0]['overview_polyline']['point']  ,*/
      'duration' : json['routes'][0]['legs'][0]['duration']['text'] ,
      'distance' : json['routes'][0]['legs'][0]['distance']['text'],
      'email' : currentUser?.email,
    };
    db.collection("Meetings").doc(meetingId).collection('EstimatedTime').doc(userId).set(result);
    print(result['distance']);
    print(result['duration']);
    return result;

  }

  Future<String> getPlaceId(String search) async {
    var baseUrl = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    var queryUrl = baseUrl + '?input=' + search + '&inputtype=textquery&key=' + key;
    var response = await http.get(
        Uri.parse(
            queryUrl ) );
    var json = convert.jsonDecode(
        response.body );
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlaces(String search) async {
    final placeId = await getPlaceId(search );
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(
        Uri.parse(
            url ) );
    var json = convert.jsonDecode(response.body);
    var result = json['result'] as Map<String, dynamic>;
    print(result);
    return result;
  }

  Future<Map<String , dynamic>> getDirection (double originLat,double originLng, double destinationLat , double destinationLng) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destinationLat,$destinationLng&key=$key';

    var response = await http.get(
        Uri.parse( url ) );
    var json = convert.jsonDecode(
        response.body );
    // print(json);
    var result ={
      'bounds_ne':json['routes'][0]['bounds']['northeast'] ,
      'bounds_sw': json['routes'][0]['bounds']['southwest'] ,
      'start_location' : json['routes'][0]['legs'][0]['start_location'] ,
      'end_location' : json['routes'][0]['legs'][0]['end_location'] ,
      'duration' : json['routes'][0]['legs'][0]['duration'] ,
      'distance' : json['routes'][0]['legs'][0]['distance'] ,
      'travel_mode': json['routes'][0]['legs'][0]['travel_mode'] ,
      'polyline':json['routes'][0]['overview_polyline']['point']  ,
    };
    print(result['distance']);
    print(result['duration']);
    return result;

  }

}


