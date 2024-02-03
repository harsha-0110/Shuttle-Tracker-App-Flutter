class Shuttle {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String status;

  Shuttle({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory Shuttle.fromJson(Map<String, dynamic> json) {
    return Shuttle(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
    );
  }
}
