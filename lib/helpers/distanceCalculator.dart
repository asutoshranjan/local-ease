import 'dart:math';

class DistanceCalculator {
  static double calculateDistance( String lati1, String loni1, String lati2, String loni2){
    double lat1 = double.parse(lati1);
    double lon1 = double.parse(loni1);
    double lat2 = double.parse(lati2);
    double lon2 = double.parse(loni2);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}
