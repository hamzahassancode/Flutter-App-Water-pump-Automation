class DataModel {
  final String title;
  final String imageName;
  final String height;
  final String width;
  final String length;

  DataModel(
    this.title,
    this.imageName,
  this.height,
  this.width,
      this.length,

  );
}

class TankModel {
  final String tankName;
  final String height;
  final String width;
  final String length;
  TankModel({
    required this.tankName,
  required this.height,
  required this.width,
    required this.length,

  });
}

List<DataModel> dataList = [
  DataModel("Rectangular Water Tank ", "assets/images/irontank.png",'1.5','1.5','1'),
  DataModel("Cylindrical Water Tank", "assets/images/balckTank.png", '2','1','1'),
  DataModel("Test Tank", "assets/images/testTank.png", '14','0.5','1'),
  DataModel("Other", "assets/images/plus0.png", '0.0','0.0','1'),
];
