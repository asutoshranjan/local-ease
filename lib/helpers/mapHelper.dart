import 'package:url_launcher/url_launcher.dart';

class LaunchMaps{
  static Future<void> launchInMaps({required String lat, required String long}) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}