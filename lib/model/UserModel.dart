class UserModel {
  String? name;
  String? email;
  Tank? tank;
  bool? isTurnedOnTank;
  bool? isTurnedOnSolar;
  bool? isAutomaticMode ;
  String? tankName;
  String? height;
  String? width;
  String? length;
  String? userType;
  double? waterTemp;
  bool? isAutomaticModeSolar;
  String? roofAutoMode;
  String? groundAutoMode;
  String? tempPercentageAutoMode;
  String? phoneNumber;
  String? waterTimeArrival;
  String? oneSignalId;
  double? latitude;
  double? longitude;
  String? dailyBills;
  String? monthlyBills;

  UserModel({
    this.name,
    this.email,
    this.tank,
    this.isAutomaticMode,
    this.isTurnedOnSolar,
    this.isTurnedOnTank,
    this.tankName,
    this.height,
    this.width,
    this.length,
    this.waterTemp,

    this.isAutomaticModeSolar,
    this.userType,
    this.roofAutoMode,
    this.groundAutoMode,
    this.tempPercentageAutoMode,
    this.phoneNumber,
    this.waterTimeArrival,
    this.oneSignalId,
    this.latitude,
    this.longitude,
    this.dailyBills,
    this.monthlyBills,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        isTurnedOnTank = json['isTurnedOnTank'],
        isTurnedOnSolar = json['isTurnedOnSolar'],
        isAutomaticMode = json['isAutomaticMode'],
        tankName = json['tankName'],
        height = json['height'],
        width = json['width'],
        length = json['length'],
        waterTemp = json['waterTemp'],
        dailyBills = json['dailyBills'],
        isAutomaticModeSolar = json['isAutomaticModeSolar'],
        userType = json['userType'],
        roofAutoMode = json['roofAutoMode'],
        groundAutoMode = json['groundAutoMode'],
        tempPercentageAutoMode = json['tempPercentageAutoMode'],
        phoneNumber = json['phoneNumber'],
        waterTimeArrival = json['waterTimeArrival'],
        oneSignalId=json['oneSignalId'],
  latitude=json['longitude'],
  longitude=json['latitude'],
        monthlyBills = json['monthlyBills'],


        tank = json['tank'] != null ? Tank.fromJson(json['tank']) : null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'tank': tank != null ? tank!.toJson() : null,
      'isTurnedOnTank': isTurnedOnTank,
      'isTurnedOnSolar': isTurnedOnSolar,
      'isAutomaticMode': isAutomaticMode,
      'tankName': tankName,
      'width': width,
      'height': height,
      'length': length,
      'waterTemp': waterTemp,
      'dailyBills': dailyBills,
      'isAutomaticModeSolar': isAutomaticModeSolar,
      'userType': userType,
      'roofAutoMode': roofAutoMode,
      'groundAutoMode': groundAutoMode,
      'tempPercentageAutoMode': tempPercentageAutoMode,
      'phoneNumber': phoneNumber,
      'waterTimeArrival': waterTimeArrival,
      'oneSignalId':oneSignalId,
      'longitude': longitude,
      'latitude':latitude,
      'monthlyBills': monthlyBills,
    };
  }
}


class Tank {
  String? cmRoof;
  String? cmGround;

  Tank({this.cmRoof, this.cmGround});

  Tank.fromJson(Map<String, dynamic> json)
      : cmRoof = json['cmRoof'],
        cmGround = json['cmGround'];

  Map<String, dynamic> toJson() {
    return {
      'cmRoof': cmRoof,
      'cmGround': cmGround,
    };
  }
}
