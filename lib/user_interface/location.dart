import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luqiaapp/operation/location_operation.dart';
import 'package:luqiaapp/operation/meeting_operation.dart';

import '../main.dart';

class MapLocation extends StatefulWidget {
   const MapLocation({Key? key, this.meetingDescreiption, this.meetingTitle, this.groupId , this.dateTime, this.email, }) : super(key: key);
  final groupId;
  final email;
  final meetingTitle;
  final meetingDescreiption;
  final dateTime;
  @override
  _MapLocationState createState() => _MapLocationState(meetingDescreiption , meetingTitle , groupId , dateTime , email);
}



class _MapLocationState extends State<MapLocation> with TickerProviderStateMixin {
  _MapLocationState(this.meetingDescreiption,this. meetingTitle, this.groupId, this.dateTime, this.email );
  var meetingTitle;
  var meetingDescreiption;
  var groupId;
  var email;
  var dateTime;


  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _search  = TextEditingController();

  final Set<Marker> _marker = Set<Marker>();
  List<double> latlng = <double>[];
  final Set<Polygon> _polygon = Set<Polygon>();
  List<LatLng> polygonLatLng = <LatLng>[];
  int polygon = 1;
  var newPoint ;

  Position? _currentPosition;
  String? _currentAddress;
  Future<void> _goToPlace(Map<String , dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)

    ));
    _setMarker(LatLng(lat, lng));
  }



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permantly denied. we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            "Location permissions are denied (actual value: $permission).");
      }
    }

    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(location.latitude);
    print(location.longitude);
    latlng[0] = location.latitude;
    latlng[1] = location.longitude;
    print(latlng[0]);
    print(latlng[1]);
    return location;
  }


  static  final CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng( 25.53548, 45.22072),
    zoom: 14.4746,
  );

  @override
  void initState(){
    super.initState();
    getCurrentLocation();
print(_currentPosition);
    _setMarker(
         LatLng(

             25.544638870251752, 45.22577494382858
        ));



  }
  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }
  getCurrentLocation() {
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;


      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _setMarker(LatLng point) async {
    setState(() {
      _marker.add(
          Marker(markerId: const MarkerId('marker'),
            position: point, )

      );
    });
  }

  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white70,
        shadowColor: Colors.black26,
        backgroundColor: Colors.white,
        title: const Text('Location SetUp'),
        leading: IconButton(
          onPressed: () {

            Navigator.pop(
              context,

            );


          },
          icon: const Icon(Icons.backspace_outlined),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add',
            onPressed: () {
              MeetingOperation.addMeetingTime(meetingTitle, meetingDescreiption, groupId, dateTime , email , newPoint);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainScreen()),
              );


            },
          ),
        ],
      ),

      body: //SingleChildScrollView(

      // child:
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _search,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Serch for meeting location '),
                  onChanged: (value){
                  },
                ),
              ),
              IconButton(
                  onPressed: ()async {
                    var place = await LocationService().getPlaces(_search.text);
                    _goToPlace(place);

                  }, icon: const Icon(Icons.search))
            ],
          ),


          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              polygons:_polygon,
              markers: _marker,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point){
                setState(() {

                  _setMarker( point);
                 newPoint = point;
                 print(newPoint);
                 // MeetingOperation.addMeetingTime(meetingTitle, meetingDescreiption, groupId, dateTime , email , point);

                  //LocationService().getDirection (point.latitude, point.longitude , point.latitude, point.longitude )  ;
                  // this is meeting place
                  // polygonLatLng.add(point);
                  // _setPolygon();
                });
              },
            ),
          ),
        ],
      ),

    );
  }


  // Future<void> _goToPlace(Map<String , dynamic> place) async {
  //   final double lat = place['geometry']['location']['lat'];
  //   final double lng = place['geometry']['location']['lng'];
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(lat, lng), zoom: 12)
  //
  //   ));
  //   _setMarker(LatLng(lat, lng));
  // }
}

