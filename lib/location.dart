import 'package:geodesy/geodesy.dart';

double calculateDistance(double customerLongitude,double customerLatitude,double tankerLongitude,double tankerLatitude,) {
  final Geodesy geodesy = Geodesy();

  final LatLng customerLocation = LatLng(customerLatitude,customerLongitude);
  final LatLng tankerLocation = LatLng(tankerLatitude,tankerLongitude);

  final double distance = geodesy.distanceBetweenTwoGeoPoints(customerLocation, tankerLocation) as double;
  double distanceInKilometers=distance/1000.0;
  // Round to two decimal places
  distanceInKilometers = double.parse(distanceInKilometers.toStringAsFixed(2));

  return distanceInKilometers;
}