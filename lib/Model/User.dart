import 'dart:math';

import 'package:intl/intl.dart';

class User {
  final String name;
  final String age;
  final String picture;
  final String title;
  final String day;
  final String date;
  final String time;
  final String city;
  final String state;
  final String country;
  final String distance;

  User({
    required this.name,
    required this.age,
    required this.picture,
    required this.title,
    required this.day,
    required this.date,
    required this.time,
    required this.city,
    required this.state,
    required this.country,
    required this.distance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String fullDateTime = json['dob']?['date'] ?? 'Unknown';
    DateTime? parsedDate = DateTime.tryParse(fullDateTime);
    String date = parsedDate != null ? DateFormat('dd-MM-yyyy').format(parsedDate) : 'Unknown';
    String time = parsedDate != null ? DateFormat('hh:mm a').format(parsedDate) : 'Unknown';
// Parse the coordinates
    double latitude = double.tryParse(json['location']?['coordinates']?['latitude'] ?? '0') ?? 0.0;
    double longitude = double.tryParse(json['location']?['coordinates']?['longitude'] ?? '0') ?? 0.0;

    const double referenceLatitude = 0.0;
    const double referenceLongitude = 0.0;

    double calculatedDistance = _calculateDistance(
      latitude,
      longitude,
      referenceLatitude,
      referenceLongitude,
    );
    String truncatedDistance = calculatedDistance.toStringAsFixed(0);
    if (truncatedDistance.length > 2) {
      truncatedDistance = truncatedDistance.substring(0, 2);
    }

    return User(
      name: '${json['name']?['first'] ?? 'Unknown'} ${json['name']?['last'] ?? ''}'.trim(),
      age: json['dob']?['age']?.toString() ?? 'N/A',
      picture: json['picture']?['large'] ?? '',
      title: json['name']?['title'] ?? 'No Title',
      day: parsedDate != null ? parsedDate.weekday.toString() : 'Unknown',
      date: date,
      time: time,
      city: json['location']?['city'] ?? 'Unknown',
      state: json['location']?['state'] ?? 'Unknown',
      country: json['location']?['country'] ?? 'Unknown',
      distance: '$truncatedDistance',

    );
  }

  // Haversine formula for calculating the distance between two geographic points
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371; // Radius of the Earth in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
