class TankerModel {
  String? name;
  String? email;
  String? userType;
  String? phoneNumber;
  double? latitude;
  double? longitude;
  bool?  isAvailable;
double? pricePerL;
String? arrivalTime;

  TankerModel({
    this.name,
    this.email,
    this.userType,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.isAvailable,
    this.pricePerL,
    this.arrivalTime,
  });

  TankerModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        userType=json['userType'],
  latitude=json['longitude'],
  longitude=json['latitude'],
  phoneNumber = json['phoneNumber'],
  isAvailable = json['isAvailable'],
  pricePerL=json['pricePerL'],
  arrivalTime=json['arrivalTime']



  ;


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'userType':userType,
      'phoneNumber': phoneNumber,
      'longitude': longitude,
      'latitude':latitude,
      'isAvailable':isAvailable,
      'pricePerL':pricePerL,
      'arrivalTime':arrivalTime,

    };
  }
}

