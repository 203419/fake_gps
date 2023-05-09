import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _latitude;
  String? _longitude;
  bool? _isMockLocation = false;
  String? _ubicacion;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    final permission = await Permission.locationWhenInUse.request();

    if (permission == PermissionStatus.granted) {
      TrustLocation.start(10);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.locationWhenInUse.request();
    }
  }

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((values) {
        setState(() {
          _latitude = values.latitude.toString();
          _longitude = values.longitude.toString();
          _isMockLocation = values.isMockLocation;
        });
        geoCode();
      });
    } catch (e) {
      print(e);
    }
  }

  void geoCode() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(_latitude!), double.parse(_longitude!));
    print(placemarks[0].country);
    _ubicacion = placemarks[0].country;
  }

  // @override
  // void dispose() {
  //   TrustLocation.stop();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Latitude: $_latitude',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Longitude: $_longitude',
            style: const TextStyle(fontSize: 20),
          ),
          // mostrar la ubicacion en tiempo real
          Text(
            'Ubication: $_ubicacion',
            style: const TextStyle(fontSize: 20),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              'Is Mock GPS: $_isMockLocation',
              style: TextStyle(
                  fontSize: 20,
                  color: _isMockLocation! ? Colors.red : Colors.green),
            ),
          ),
        ],
      ),
    ));
  }
}
