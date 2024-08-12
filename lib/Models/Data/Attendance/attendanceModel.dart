class CheckInData {
  String? postalCode;
  String? route;
  String? district;
  String? longitude;
  String? latitude;
  CheckInData(
      {this.district,
      this.latitude,
      this.longitude,
      this.postalCode,
      this.route});
  Map<String, dynamic> tomap() {
    return {
      "postalCode": postalCode,
      "route": route,
      "district": district,
      "longitude": longitude,
      "latitude": latitude,
    };
  }
}
