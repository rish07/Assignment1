import 'package:geolocator/geolocator.dart';


class LocationService {

  static LocationService _instance = new LocationService();
  //Location location ;
  final Geolocator _geoLocator = Geolocator();
  UserLocation _currentLocation;

  static LocationService getInstance() {
    if (_instance == null) {
      _instance =  new LocationService();
    }
    return _instance;
  }





  Future<UserLocation>  getCurrentLocation() async {
    final Geolocator geolocator =  Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentLocation = UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      return _currentLocation;
    }).catchError((e) {
      print(e);
      return null;
    });
    return _currentLocation;
  }

  Future<List<Placemark>> getLocationAddress (double latitude , double longitude ) async {
    final List<Placemark> placeMarks =
    await _geoLocator.placemarkFromCoordinates(latitude ?? 0.0 , longitude?? 0.0 );
    return placeMarks;
  }

/* checkLocationPermissions() async {
    PermissionStatus permissionGrantedResult = await location.hasPermission();
    returnpermissionGrantedResult;
  }

  _requestPermission() async {
    if (_permissionGranted != PermissionStatus.GRANTED) {
      PermissionStatus permissionRequestedResult =
      await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.GRANTED) {
        return;
      }
    }
  }*/


}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({this.latitude, this.longitude});
}