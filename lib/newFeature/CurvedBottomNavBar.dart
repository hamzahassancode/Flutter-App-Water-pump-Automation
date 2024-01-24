import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/newFeature/profileUI/ProfileScreen.dart';
import '../Screens/System/components/NavBar.dart';
import '../Screens/System/components/data.dart';
import '../Screens/System/components/solarCells.dart';
import '../Screens/System/components/tank.dart';
import '../components/designUI.dart';


class CurvedNavPage extends StatefulWidget {
  const CurvedNavPage({Key? key}) : super(key: key);

  @override
  State<CurvedNavPage> createState() => _CurvedNavPageState();
}

class _CurvedNavPageState extends State<CurvedNavPage> {
  Color colorth=Colors.black;

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar( context,'Automatic Pump'),
      drawer: NavBar(),
      body: Center(
        child: _widgitItems[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor:  Color(0xFFBAD3FF),
          animationDuration: Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItemsCurv),
    );
  }
}
final _navBarItemsCurv=[  Icon(Icons.home),Icon(Icons.water_drop_rounded),Icon(Icons.sunny)];
final _widgitItems = [const DataPage(), const TankPage(), const SolarCellsPage(),ProfileScreen(),];
